import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/songs_provider.dart';
import '../../providers/audio_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/song.dart';
import '../../utils/constants.dart';
import '../../widgets/song_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final songsProvider = Provider.of<SongsProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      if (authProvider.currentUser != null) {
        songsProvider.setCurrentUserId(authProvider.currentUser!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),
              
              // Favorites List
              Expanded(
                child: Consumer<SongsProvider>(
                  builder: (context, songsProvider, child) {
                    if (songsProvider.favorites.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.favorite_border,
                              size: 80,
                              color: AppColors.textSecondary.withOpacity(0.5),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              'No favorites yet',
                              style: AppTextStyles.heading3.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'Start adding songs to your favorites',
                              style: AppTextStyles.body2.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            ElevatedButton(
                              onPressed: () {
                                // Navigate to home
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: AppColors.textPrimary,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.lg,
                                  vertical: AppSpacing.md,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: AppBorderRadius.medium,
                                ),
                              ).copyWith(
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.transparent,
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                  borderRadius: AppBorderRadius.medium,
                                  boxShadow: AppShadows.primaryShadow,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.lg,
                                  vertical: AppSpacing.md,
                                ),
                                child: Text(
                                  'Discover Music',
                                  style: AppTextStyles.button,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      itemCount: songsProvider.favorites.length,
                      itemBuilder: (context, index) {
                        final song = songsProvider.favorites[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: SongCard(
                            song: song,
                            onPlayPressed: () => _playSong(song),
                            onFavoritePressed: () => _toggleFavorite(song),
                            onDownloadPressed: () => _downloadSong(song),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: AppBorderRadius.large,
              boxShadow: AppShadows.neonShadow,
            ),
            child: const Icon(
              Icons.favorite,
              color: AppColors.textPrimary,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FAVORITES',
                  style: AppTextStyles.heading3.copyWith(
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  'Your loved tracks',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Consumer<SongsProvider>(
            builder: (context, songsProvider, child) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: AppBorderRadius.small,
                  border: Border.all(
                    color: AppColors.primary,
                    width: 1,
                  ),
                ),
                child: Text(
                  '${songsProvider.favorites.length}',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _playSong(Song song) {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    audioProvider.playSong(song);
  }

  void _toggleFavorite(Song song) {
    final songsProvider = Provider.of<SongsProvider>(context, listen: false);
    songsProvider.toggleFavorite(song);
  }

  void _downloadSong(Song song) {
    final songsProvider = Provider.of<SongsProvider>(context, listen: false);
    songsProvider.downloadSong(song);
  }
} 