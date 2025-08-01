import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song.dart';
import '../services/audio_service.dart';

class AudioProvider extends ChangeNotifier {
  final AudioService _audioService = AudioService();
  Song? _currentSong;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isLoading = false;

  Song? get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  Duration get position => _position;
  Duration get duration => _duration;
  bool get isLoading => _isLoading;

  AudioProvider() {
    _initializeAudio();
  }

  void _initializeAudio() {
    // Listen to player state changes
    _audioService.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      _isLoading = state.processingState == ProcessingState.loading ||
                   state.processingState == ProcessingState.buffering;
      notifyListeners();
    });

    // Listen to position changes
    _audioService.positionStream.listen((position) {
      if (position != null) {
        _position = position;
        notifyListeners();
      }
    });

    // Listen to duration changes
    _audioService.durationStream.listen((duration) {
      if (duration != null) {
        _duration = duration;
        notifyListeners();
      }
    });
  }

  Future<void> playSong(Song song) async {
    try {
      await _audioService.playSong(song);
      _currentSong = song;
      notifyListeners();
    } catch (e) {
      print('Error playing song: $e');
    }
  }

  Future<void> pause() async {
    try {
      await _audioService.pause();
    } catch (e) {
      print('Error pausing: $e');
    }
  }

  Future<void> resume() async {
    try {
      await _audioService.resume();
    } catch (e) {
      print('Error resuming: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _audioService.stop();
      _currentSong = null;
      _position = Duration.zero;
      _duration = Duration.zero;
      notifyListeners();
    } catch (e) {
      print('Error stopping: $e');
    }
  }

  Future<void> seekTo(Duration position) async {
    try {
      await _audioService.seekTo(position);
    } catch (e) {
      print('Error seeking: $e');
    }
  }

  Future<void> setVolume(double volume) async {
    try {
      await _audioService.setVolume(volume);
    } catch (e) {
      print('Error setting volume: $e');
    }
  }

  void dispose() {
    _audioService.dispose();
    super.dispose();
  }
} 