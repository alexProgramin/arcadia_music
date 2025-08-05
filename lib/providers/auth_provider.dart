import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/supabase_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  AuthProvider() {
    _initializeAuth();
  }

  void _initializeAuth() {
    // Listen to auth state changes
    SupabaseService.authStateChanges.listen((data) {
      final user = data.session?.user;
      if (user != null) {
        _currentUser = User(
          id: user.id,
          email: user.email ?? '',
          name: user.userMetadata?['name'],
          avatarUrl: user.userMetadata?['avatar_url'],
          createdAt: DateTime.tryParse(user.createdAt) ?? DateTime.now(),
        );
      } else {
        _currentUser = null;
      }
      notifyListeners();
    });
  }

  Future<bool> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await SupabaseService.signUp(
        email: email,
        password: password,
        name: name,
      );
      
      if (response.user != null) {
        // Actualizar el perfil del usuario con el nombre si se proporciona
        if (name != null && name.isNotEmpty) {
          await _updateUserProfile(response.user!.id, name);
        }
        return true;
      }
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await SupabaseService.signIn(email: email, password: password);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signInWithGoogle() async {
    _setLoading(true);
    _clearError();

    try {
      await SupabaseService.signInWithGoogle();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    _clearError();

    try {
      await SupabaseService.signOut();
      _currentUser = null;
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _updateUserProfile(String userId, String name) async {
    try {
      await SupabaseService.client
          .from('profiles')
          .upsert({
            'id': userId,
            'name': name,
            'updated_at': DateTime.now().toIso8601String(),
          });
    } catch (e) {
      print('Error updating user profile: $e');
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