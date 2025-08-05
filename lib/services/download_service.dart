import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/song.dart';

class DownloadService {
  static final DownloadService _instance = DownloadService._internal();
  factory DownloadService() => _instance;
  DownloadService._internal();

  bool _permissionRequested = false;

  /// Verifica si ya tenemos permisos de almacenamiento
  Future<bool> hasStoragePermission() async {
    if (!Platform.isAndroid) return true;
    return await Permission.storage.isGranted;
  }

  /// Solicita permisos de almacenamiento solo una vez
  Future<bool> requestStoragePermission() async {
    if (!Platform.isAndroid) return true;
    if (_permissionRequested) return await hasStoragePermission();
    _permissionRequested = true;
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  /// Verifica si los permisos están permanentemente denegados
  Future<bool> isPermissionPermanentlyDenied() async {
    if (!Platform.isAndroid) return false;
    return await Permission.storage.isPermanentlyDenied;
  }

  /// Abre la configuración de la app
  Future<void> openAppSettingsPage() async {
    try {
      await openAppSettings();
    } catch (e) {
      print('Error opening app settings: $e');
    }
  }

  /// Descarga una canción con manejo robusto de errores
  Future<String?> downloadSong(Song song) async {
    try {
      // Verificar permisos antes de descargar
      final hasPermission = await requestStoragePermission();
      if (!hasPermission) {
        throw Exception('Permiso de almacenamiento denegado.');
      }

      // Verificar que la URL del audio sea válida
      if (song.audioUrl.isEmpty) {
        throw Exception('URL de audio no válida');
      }

      // Obtener directorio de descarga
      final directory = await _getDownloadDirectory();

      // Crear nombre de archivo seguro
      final filename = _createSafeFilename(song);
      final file = File('${directory.path}/$filename');

      // Verificar si el archivo ya existe
      if (await file.exists()) {
        return file.path;
      }

      // Descargar archivo con timeout y headers apropiados
      final response = await http.get(
        Uri.parse(song.audioUrl),
        headers: {
          'User-Agent': 'ArcadiaMusic/1.0',
          'Accept': 'audio/*',
        },
      ).timeout(const Duration(minutes: 5));

      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        print('Song downloaded successfully: ${file.path}');
        return file.path;
      } else {
        throw Exception('Error al descargar archivo: HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('Error downloading song: $e');
      _handleDownloadError(e);
      rethrow;
    }
  }

  /// Obtiene el directorio de descarga apropiado
  Future<Directory> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      final dir = await getExternalStorageDirectory();
      final appDir = Directory('${dir!.path}/ArcadiaMusic');
      if (!await appDir.exists()) {
        await appDir.create(recursive: true);
      }
      return appDir;
    }
    // iOS y otros
    final appDir = await getApplicationDocumentsDirectory();
    final fallbackDir = Directory('${appDir.path}/downloads');
    if (!await fallbackDir.exists()) {
      await fallbackDir.create(recursive: true);
    }
    return fallbackDir;
  }

  /// Crea un nombre de archivo seguro
  String _createSafeFilename(Song song) {
    final safeTitle = song.title
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '_')
        .toLowerCase();
    return '${song.id}_$safeTitle.mp3';
  }

  /// Maneja errores de descarga de manera específica
  void _handleDownloadError(dynamic error) {
    if (error.toString().contains('SocketException')) {
      throw Exception('Error de conexión. Verifica tu conexión a internet.');
    } else if (error.toString().contains('TimeoutException')) {
      throw Exception('Tiempo de espera agotado. Intenta de nuevo.');
    } else if (error.toString().contains('Permission denied')) {
      throw Exception('Error de permisos. Por favor, habilita los permisos de almacenamiento en la configuración de la app.');
    } else if (error.toString().contains('FileSystemException')) {
      throw Exception('Error de acceso al almacenamiento. Verifica los permisos de la app.');
    } else {
      throw Exception('Error al descargar la canción: ${error.toString()}');
    }
  }

  /// Verifica si una canción ya está descargada
  Future<bool> isSongDownloaded(String songId) async {
    try {
      final directory = await _getDownloadDirectory();

      if (!await directory.exists()) return false;

      final files = directory.listSync();
      return files.any((file) => file.path.contains(songId));
    } catch (e) {
      print('Error checking if song is downloaded: $e');
      return false;
    }
  }

  /// Obtiene la ruta de una canción descargada
  Future<String?> getDownloadedSongPath(String songId) async {
    try {
      final directory = await _getDownloadDirectory();

      if (!await directory.exists()) return null;

      final files = directory.listSync();
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
      print('Error getting downloaded song path: $e');
      return null;
    }
  }

  /// Elimina una canción descargada
  Future<void> deleteDownloadedSong(String songId) async {
    try {
      final path = await getDownloadedSongPath(songId);
      if (path != null) {
        final file = File(path);
        if (await file.exists()) {
          await file.delete();
          print('Song deleted successfully: $path');
        }
      }
    } catch (e) {
      print('Error deleting downloaded song: $e');
    }
  }

  /// Obtiene la lista de canciones descargadas
  Future<List<String>> getDownloadedSongs() async {
    try {
      final directory = await _getDownloadDirectory();

      if (!await directory.exists()) return [];

      final files = directory.listSync();
      return files
          .where((file) => file.path.endsWith('.mp3'))
          .map((file) => file.path)
          .toList();
    } catch (e) {
      print('Error getting downloaded songs: $e');
      return [];
    }
  }
}