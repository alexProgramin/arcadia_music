import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import '../models/song.dart';
import '../models/user.dart' as app_user;

class SupabaseService {
  static const String _supabaseUrl = 'https://mwnedjxdabfwtghapgke.supabase.co';
  static const String _supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im13bmVkanhkYWJmd3RnaGFwZ2tlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQwODMzOTMsImV4cCI6MjA2OTY1OTM5M30.7uSUgodKqDE1aA2B3rfrbYl1bUQzj0BtP_KIUJIZvKw';
  
  static SupabaseClient get client => Supabase.instance.client;

  // Initialize Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: _supabaseUrl,
      anonKey: _supabaseAnonKey,
    );
  }

  // Authentication methods
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    return await client.auth.signUp(
      email: email,
      password: password,
      data: name != null ? {'name': name} : null,
    );
  }

  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

static Future<void> signInWithGoogle() async {
  await client.auth.signInWithOAuth(
    OAuthProvider.google,
    redirectTo: 'com.arcadia_music://login-callback/', // ← ¡EXACTAMENTE ASÍ!
  );
}


  static Future<void> signOut() async {
    await client.auth.signOut();
  }

  static app_user.User? getCurrentUser() {
    final authUser = client.auth.currentUser;
    if (authUser == null) return null;
    
    return app_user.User(
      id: authUser.id,
      email: authUser.email ?? '',
      name: authUser.userMetadata?['name'],
      avatarUrl: authUser.userMetadata?['avatar_url'],
      createdAt: DateTime.tryParse(authUser.createdAt) ?? DateTime.now(),
    );
  }

  static Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;

  // Songs CRUD operations
  static Future<List<Song>> getSongs({String? searchQuery, String? genre}) async {
    var query = client.from('songs').select('*');
    
    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query.ilike('title', '%$searchQuery%');
    }
    
    if (genre != null && genre.isNotEmpty) {
      query = query.eq('genre', genre);
    }
    
    final response = await query.order('created_at', ascending: false);
    return (response as List).map((json) => Song.fromJson(json)).toList();
  }

  static Future<Song> getSongById(String id) async {
    final response = await client.from('songs').select('*').eq('id', id).single();
    return Song.fromJson(response);
  }

  static Future<void> addSong(Song song) async {
    await client.from('songs').insert(song.toJson());
  }

  static Future<void> updateSong(Song song) async {
    await client.from('songs').update(song.toJson()).eq('id', song.id);
  }

  static Future<void> deleteSong(String id) async {
    await client.from('songs').delete().eq('id', id);
  }

  // Favorites operations
  static Future<List<Song>> getFavorites(String userId) async {
    final response = await client
        .from('favorites')
        .select('songs(*)')
        .eq('user_id', userId);
    
    return (response as List)
        .map((json) => Song.fromJson(json['songs']))
        .toList();
  }

  static Future<void> addToFavorites(String userId, String songId) async {
    await client.from('favorites').insert({
      'user_id': userId,
      'song_id': songId,
    });
  }

  static Future<void> removeFromFavorites(String userId, String songId) async {
    await client
        .from('favorites')
        .delete()
        .eq('user_id', userId)
        .eq('song_id', songId);
  }

  static Future<bool> isFavorite(String userId, String songId) async {
    final response = await client
        .from('favorites')
        .select('*')
        .eq('user_id', userId)
        .eq('song_id', songId);
    
    return (response as List).isNotEmpty;
  }

  // Downloads operations
  static Future<List<Song>> getDownloads(String userId) async {
    final response = await client
        .from('downloads')
        .select('songs(*)')
        .eq('user_id', userId);
    
    return (response as List)
        .map((json) => Song.fromJson(json['songs']))
        .toList();
  }

  static Future<void> addToDownloads(String userId, String songId) async {
    await client.from('downloads').insert({
      'user_id': userId,
      'song_id': songId,
      'downloaded_at': DateTime.now().toIso8601String(),
    });
  }

  static Future<void> removeFromDownloads(String userId, String songId) async {
    await client
        .from('downloads')
        .delete()
        .eq('user_id', userId)
        .eq('song_id', songId);
  }

  static Future<bool> isDownloaded(String userId, String songId) async {
    final response = await client
        .from('downloads')
        .select('*')
        .eq('user_id', userId)
        .eq('song_id', songId);
    
    return (response as List).isNotEmpty;
  }

  // User profile operations
  static Future<app_user.User?> getUserProfile(String userId) async {
    final response = await client
        .from('profiles')
        .select('*')
        .eq('id', userId)
        .single();
    
    if (response == null) return null;
    return app_user.User.fromJson(response);
  }

  static Future<void> updateUserProfile(app_user.User user) async {
    await client
        .from('profiles')
        .update(user.toJson())
        .eq('id', user.id);
  }
} 