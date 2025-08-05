import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/songs_provider.dart';
import '../../providers/audio_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/song.dart';
import '../../utils/constants.dart';
import '../../utils/app_localizations.dart';
import '../../widgets/song_card.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/genre_chips.dart';
import '../../widgets/download_error_dialog.dart';
import '../../services/permission_helper.dart' as PermissionService;

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
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(l10n),
              
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
                              l10n.get('noSongsFound'),
                              style: AppTextStyles.heading3.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              l10n.get('tryAdjustingSearch'),
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

  Widget _buildHeader(AppLocalizations l10n) {
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
                  l10n.get('discoverNextFavorite'),
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

  void _downloadSong(Song song) async {
    final songsProvider = Provider.of<SongsProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context);
    
    try {
      // Verificar permisos antes de intentar descargar
      final hasPermissions = await PermissionService.PermissionHelper().hasStoragePermission();
      
      if (!hasPermissions) {
        // Solicitar permisos automáticamente
        final granted = await PermissionService.PermissionHelper().requestStoragePermission();
        
        if (!granted) {
          // Si los permisos están permanentemente denegados, abrir configuración
          if (await PermissionService.PermissionHelper().isPermissionPermanentlyDenied()) {
            await PermissionService.PermissionHelper().openAppSettings();
          }
          
          // Mostrar mensaje de error
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Permisos de almacenamiento requeridos. Por favor, habilita los permisos en la configuración.',
                  style: AppTextStyles.body2.copyWith(
                    color: Colors.white,
                  ),
                ),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: AppBorderRadius.medium,
                ),
                margin: const EdgeInsets.all(AppSpacing.md),
                duration: const Duration(seconds: 4),
              ),
            );
          }
          return;
        }
      }
      
      // Intentar descargar la canción
      await songsProvider.downloadSong(song);
      
      // Mostrar notificación de éxito
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(
                  Icons.download_done,
                  color: Colors.white,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.get('songDownloadedSuccessfully'),
                    style: AppTextStyles.body2.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: AppBorderRadius.medium,
            ),
            margin: const EdgeInsets.all(AppSpacing.md),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // Mostrar diálogo de error personalizado
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => DownloadErrorDialog(
            errorMessage: e.toString(),
            onRetry: () => _downloadSong(song),
            onOpenSettings: () {
              Navigator.of(context).pop();
              _openAppSettings();
            },
          ),
        );
      }
    }
  }



  void _openAppSettings() async {
    try {
      await PermissionService.PermissionHelper().openAppSettings();
    } catch (e) {
      // Si no se puede abrir la configuración, mostrar un mensaje
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Por favor, ve a Configuración > Aplicaciones > Arcadia Music > Permisos',
              style: AppTextStyles.body2.copyWith(
                color: Colors.white,
              ),
            ),
            backgroundColor: AppColors.warning,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: AppBorderRadius.medium,
            ),
            margin: const EdgeInsets.all(AppSpacing.md),
          ),
        );
      }
    }
  }
} 