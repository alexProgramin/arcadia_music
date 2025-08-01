import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/audio_provider.dart';
import '../utils/constants.dart';

class AudioPlayerWidget extends StatelessWidget {
  const AudioPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioProvider>(
      builder: (context, audioProvider, child) {
        if (audioProvider.currentSong == null) {
          return const SizedBox.shrink();
        }

        return Container(
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  // Song Image
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: AppBorderRadius.medium,
                      boxShadow: AppShadows.cardShadow,
                    ),
                    child: ClipRRect(
                      borderRadius: AppBorderRadius.medium,
                      child: CachedNetworkImage(
                        imageUrl: audioProvider.currentSong!.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppColors.surface,
                          child: const Icon(
                            Icons.music_note,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.surface,
                          child: const Icon(
                            Icons.error,
                            color: AppColors.error,
                            size: 20,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          audioProvider.currentSong!.title,
                          style: AppTextStyles.body1.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          audioProvider.currentSong!.description,
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        // Progress Bar
                        LinearProgressIndicator(
                          value: audioProvider.duration.inMilliseconds > 0
                              ? audioProvider.position.inMilliseconds /
                                  audioProvider.duration.inMilliseconds
                              : 0.0,
                          backgroundColor: AppColors.textMuted.withOpacity(0.3),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: AppSpacing.md),
                  
                  // Control Buttons
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Previous Button
                      IconButton(
                        onPressed: () {
                          // TODO: Implement previous song
                        },
                        icon: const Icon(
                          Icons.skip_previous,
                          color: AppColors.textSecondary,
                          size: 24,
                        ),
                      ),
                      
                      // Play/Pause Button
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: AppBorderRadius.large,
                          boxShadow: AppShadows.neonShadow,
                        ),
                        child: IconButton(
                          onPressed: () {
                            if (audioProvider.isPlaying) {
                              audioProvider.pause();
                            } else {
                              audioProvider.resume();
                            }
                          },
                          icon: Icon(
                            audioProvider.isPlaying ? Icons.pause : Icons.play_arrow,
                            color: AppColors.textPrimary,
                            size: 24,
                          ),
                        ),
                      ),
                      
                      // Next Button
                      IconButton(
                        onPressed: () {
                          // TODO: Implement next song
                        },
                        icon: const Icon(
                          Icons.skip_next,
                          color: AppColors.textSecondary,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
} 