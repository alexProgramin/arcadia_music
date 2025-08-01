import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/songs_provider.dart';
import '../../providers/audio_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/song.dart';
import '../../utils/constants.dart';
import '../../widgets/song_card.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/genre_chips.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final songsProvider = Provider.of<SongsProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      if (authProvider.currentUser != null) {
        songsProvider.setCurrentUserId(authProvider.currentUser!.id);
      }
      
      songsProvider.loadSongs();
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
              
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                child: CustomSearchBar(
                  onChanged: (query) {
                    Provider.of<SongsProvider>(context, listen: false)
                        .setSearchQuery(query);
                  },
                ),
              ),
              
              // Genre Chips
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: GenreChips(
                  onGenreSelected: (genre) {
                    Provider.of<SongsProvider>(context, listen: false)
                        .setSelectedGenre(genre);
                  },
                ),
              ),
              
              const SizedBox(height: AppSpacing.md),
              
              // Songs List
              Expanded(
                child: Consumer<SongsProvider>(
                  builder: (context, songsProvider, child) {
                    if (songsProvider.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                      );
                    }
                    
                    if (songsProvider.filteredSongs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.music_note,
                              size: 80,
                              color: AppColors.textSecondary.withOpacity(0.5),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              'No songs found',
                              style: AppTextStyles.heading3.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'Try adjusting your search or filters',
                              style: AppTextStyles.body2.copyWith(
                                color: AppColors.textMuted,
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
                      itemCount: songsProvider.filteredSongs.length,
                      itemBuilder: (context, index) {
                        final song = songsProvider.filteredSongs[index];
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
              Icons.music_note,
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
                  'ARCADIA MUSIC',
                  style: AppTextStyles.heading3.copyWith(
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  'Discover your next favorite track',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              if (authProvider.currentUser?.avatarUrl != null) {
                return CircleAvatar(
                  backgroundImage: NetworkImage(
                    authProvider.currentUser!.avatarUrl!,
                  ),
                  radius: 20,
                );
              }
              return CircleAvatar(
                backgroundColor: AppColors.primary,
                radius: 20,
                child: Icon(
                  Icons.person,
                  color: AppColors.textPrimary,
                  size: 20,
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