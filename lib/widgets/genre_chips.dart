import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';
import '../providers/songs_provider.dart';

class GenreChips extends StatefulWidget {
  final Function(String) onGenreSelected;

  const GenreChips({
    super.key,
    required this.onGenreSelected,
  });

  @override
  State<GenreChips> createState() => _GenreChipsState();
}

class _GenreChipsState extends State<GenreChips> {
  String _selectedGenre = 'All';

  @override
  Widget build(BuildContext context) {
    return Consumer<SongsProvider>(
      builder: (context, songsProvider, child) {
        return SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: SongsProvider.genres.length,
            itemBuilder: (context, index) {
              final genre = SongsProvider.genres[index];
              final isSelected = songsProvider.selectedGenre == genre ||
                  (songsProvider.selectedGenre.isEmpty && genre == 'All');
              
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: GestureDetector(
                  onTap: () {
                    widget.onGenreSelected(genre);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? AppColors.primaryGradient
                          : null,
                      color: isSelected
                          ? null
                          : AppColors.cardBackground,
                      borderRadius: AppBorderRadius.large,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textMuted.withOpacity(0.3),
                        width: 1,
                      ),
                      boxShadow: isSelected
                          ? AppShadows.neonShadow
                          : AppShadows.cardShadow,
                    ),
                    child: Center(
                      child: Text(
                        genre,
                        style: AppTextStyles.body2.copyWith(
                          color: isSelected
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
} 