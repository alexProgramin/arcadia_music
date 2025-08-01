import 'package:flutter/material.dart';
import '../models/song.dart';
import '../services/supabase_service.dart';
import '../services/download_service.dart';

class SongsProvider extends ChangeNotifier {
  List<Song> _songs = [];
  List<Song> _filteredSongs = [];
  List<Song> _favorites = [];
  List<Song> _downloads = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  String _selectedGenre = '';
  String _currentUserId = '';

  List<Song> get songs => _songs;
  List<Song> get filteredSongs => _filteredSongs;
  List<Song> get favorites => _favorites;
  List<Song> get downloads => _downloads;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  String get selectedGenre => _selectedGenre;

  // Available genres for filtering
  static const List<String> genres = [
    'All',
    'Electronic',
    'House',
    'Techno',
    'Trance',
    'Dubstep',
    'Ambient',
    'Chillout',
    'Drum & Bass',
    'Progressive',
  ];

  void setCurrentUserId(String userId) {
    _currentUserId = userId;
    loadFavorites();
    loadDownloads();
  }

  Future<void> loadSongs() async {
    _setLoading(true);
    _clearError();

    try {
      _songs = await SupabaseService.getSongs();
      _applyFilters();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadFavorites() async {
    if (_currentUserId.isEmpty) return;

    try {
      _favorites = await SupabaseService.getFavorites(_currentUserId);
      notifyListeners();
    } catch (e) {
      print('Error loading favorites: $e');
    }
  }

  Future<void> loadDownloads() async {
    if (_currentUserId.isEmpty) return;

    try {
      _downloads = await SupabaseService.getDownloads(_currentUserId);
      notifyListeners();
    } catch (e) {
      print('Error loading downloads: $e');
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void setSelectedGenre(String genre) {
    _selectedGenre = genre;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredSongs = _songs.where((song) {
      // Apply search filter
      final matchesSearch = _searchQuery.isEmpty ||
          song.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          song.description.toLowerCase().contains(_searchQuery.toLowerCase());

      // Apply genre filter
      final matchesGenre = _selectedGenre.isEmpty ||
          _selectedGenre == 'All' ||
          song.genre == _selectedGenre;

      return matchesSearch && matchesGenre;
    }).toList();

    notifyListeners();
  }

  Future<void> toggleFavorite(Song song) async {
    if (_currentUserId.isEmpty) return;

    try {
      final isFavorite = await SupabaseService.isFavorite(_currentUserId, song.id);
      
      if (isFavorite) {
        await SupabaseService.removeFromFavorites(_currentUserId, song.id);
      } else {
        await SupabaseService.addToFavorites(_currentUserId, song.id);
      }

      // Reload favorites
      await loadFavorites();
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> downloadSong(Song song) async {
    try {
      final downloadPath = await DownloadService().downloadSong(song);
      if (downloadPath != null) {
        await SupabaseService.addToDownloads(_currentUserId, song.id);
        await loadDownloads();
      }
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> removeDownload(Song song) async {
    try {
      await DownloadService().deleteDownloadedSong(song.id);
      await SupabaseService.removeFromDownloads(_currentUserId, song.id);
      await loadDownloads();
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<bool> isSongFavorite(String songId) async {
    if (_currentUserId.isEmpty) return false;
    
    try {
      return await SupabaseService.isFavorite(_currentUserId, songId);
    } catch (e) {
      return false;
    }
  }

  Future<bool> isSongDownloaded(String songId) async {
    if (_currentUserId.isEmpty) return false;
    
    try {
      return await SupabaseService.isDownloaded(_currentUserId, songId);
    } catch (e) {
      return false;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
} 