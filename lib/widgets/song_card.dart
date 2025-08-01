import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/song.dart';
import '../providers/songs_provider.dart';
import '../providers/audio_provider.dart';
import '../utils/constants.dart';

class SongCard extends StatelessWidget {
  final Song song;
  final VoidCallback onPlayPressed;
  final VoidCallback onFavoritePressed;
  final VoidCallback onDownloadPressed;

  const SongCard({
    super.key,
    required this.song,
    required this.onPlayPressed,
    required this.onFavoritePressed,
    required this.onDownloadPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<SongsProvider, AudioProvider>(
      builder: (context, songsProvider, audioProvider, child) {
        final isPlaying = audioProvider.currentSong?.id == song.id && 
                         audioProvider.isPlaying;
        final isFavorite = songsProvider.favorites.any((s) => s.id == song.id);
        final isDownloaded = songsProvider.downloads.any((s) => s.id == song.id);

        return Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: AppBorderRadius.medium,
            boxShadow: AppShadows.cardShadow,
            border: Border.all(
              color: isPlaying 
                  ? AppColors.primary 
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                // Song Image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: AppBorderRadius.medium,
                    boxShadow: AppShadows.cardShadow,
                  ),
                  child: ClipRRect(
                    borderRadius: AppBorderRadius.medium,
                    child: CachedNetworkImage(
                      imageUrl: song.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.surface,
                        child: const Icon(
                          Icons.music_note,
                          color: AppColors.textSecondary,
                          size: 30,
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.surface,
                        child: const Icon(
                          Icons.error,
                          color: AppColors.error,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: AppSpacing.md),
                
                // Song Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        song.title,
                        style: AppTextStyles.heading3.copyWith(
                          fontSize: 18,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        song.description,
                        style: AppTextStyles.body2,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Container(
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
                              song.genre,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (isPlaying) ...[
                            const SizedBox(width: AppSpacing.sm),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: AppSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withOpacity(0.2),
                                borderRadius: AppBorderRadius.small,
                                border: Border.all(
                                  color: AppColors.accent,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.play_arrow,
                                    size: 12,
                                    color: AppColors.accent,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Playing',
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.accent,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: AppSpacing.sm),
                
                // Action Buttons
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Play Button
                    GestureDetector(
                      onTap: onPlayPressed,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: isPlaying
                              ? AppColors.primaryGradient
                              : null,
                          color: isPlaying
                              ? null
                              : AppColors.surface,
                          borderRadius: AppBorderRadius.large,
                          boxShadow: isPlaying
                              ? AppShadows.neonShadow
                              : AppShadows.cardShadow,
                        ),
                        child: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: isPlaying
                              ? AppColors.textPrimary
                              : AppColors.primary,
                          size: 24,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: AppSpacing.sm),
                    
                    // Favorite Button
                    GestureDetector(
                      onTap: onFavoritePressed,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isFavorite
                              ? AppColors.error.withOpacity(0.2)
                              : AppColors.surface,
                          borderRadius: AppBorderRadius.medium,
                          border: Border.all(
                            color: isFavorite
                                ? AppColors.error
                                : AppColors.textMuted.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite
                              ? AppColors.error
                              : AppColors.textSecondary,
                          size: 20,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: AppSpacing.sm),
                    
                    // Download Button
                    GestureDetector(
                      onTap: onDownloadPressed,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isDownloaded
                              ? AppColors.success.withOpacity(0.2)
                              : AppColors.surface,
                          borderRadius: AppBorderRadius.medium,
                          border: Border.all(
                            color: isDownloaded
                                ? AppColors.success
                                : AppColors.textMuted.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          isDownloaded ? Icons.download_done : Icons.download,
                          color: isDownloaded
                              ? AppColors.success
                              : AppColors.textSecondary,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
} 