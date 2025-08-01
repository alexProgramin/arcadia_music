import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/song.dart';

class DownloadService {
  static final DownloadService _instance = DownloadService._internal();
  factory DownloadService() => _instance;
  DownloadService._internal();

  Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      return status.isGranted;
    }
    return true;
  }

  Future<String?> downloadSong(Song song) async {
    try {
      // Request permissions
      final hasPermission = await requestPermissions();
      if (!hasPermission) {
        throw Exception('Storage permission denied');
      }

      // Get download directory
      final directory = await getApplicationDocumentsDirectory();
      final downloadsDir = Directory('${directory.path}/downloads');
      if (!await downloadsDir.exists()) {
        await downloadsDir.create(recursive: true);
      }

      // Create filename
      final filename = '${song.id}_${song.title.replaceAll(RegExp(r'[^\w\s-]'), '')}.mp3';
      final file = File('${downloadsDir.path}/$filename');

      // Download file
      final response = await http.get(Uri.parse(song.audioUrl));
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        return file.path;
      } else {
        throw Exception('Failed to download file: ${response.statusCode}');
      }
    } catch (e) {
      print('Error downloading song: $e');
      rethrow;
    }
  }

  Future<bool> isSongDownloaded(String songId) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final downloadsDir = Directory('${directory.path}/downloads');
      
      if (!await downloadsDir.exists()) return false;
      
      final files = downloadsDir.listSync();
      return files.any((file) => file.path.contains(songId));
    } catch (e) {
      return false;
    }
  }

  Future<String?> getDownloadedSongPath(String songId) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final downloadsDir = Directory('${directory.path}/downloads');
      
      if (!await downloadsDir.exists()) return null;
      
      final files = downloadsDir.listSync();
      FileSystemEntity? downloadedFile;
      try {
        downloadedFile = files.firstWhere(
          (file) => file.path.contains(songId),
        );
      } catch (e) {
        downloadedFile = null;
      }
      
      return downloadedFile?.path;
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteDownloadedSong(String songId) async {
    try {
      final path = await getDownloadedSongPath(songId);
      if (path != null) {
        final file = File(path);
        if (await file.exists()) {
          await file.delete();
        }
      }
    } catch (e) {
      print('Error deleting downloaded song: $e');
    }
  }

  Future<List<String>> getDownloadedSongs() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final downloadsDir = Directory('${directory.path}/downloads');
      
      if (!await downloadsDir.exists()) return [];
      
      final files = downloadsDir.listSync();
      return files
          .where((file) => file.path.endsWith('.mp3'))
          .map((file) => file.path)
          .toList();
    } catch (e) {
      return [];
    }
  }
} 