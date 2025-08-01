import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/songs_provider.dart';
import '../../models/user.dart';
import '../../utils/constants.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              if (authProvider.currentUser == null) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  // Header
                  _buildHeader(authProvider.currentUser!),
                  
                  // Profile Info
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        children: [
                          // User Stats
                          _buildUserStats(),
                          
                          const SizedBox(height: AppSpacing.lg),
                          
                          // Profile Actions
                          _buildProfileActions(context),
                          
                          const SizedBox(height: AppSpacing.lg),
                          
                          // App Info
                          _buildAppInfo(),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(User user) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: AppBorderRadius.extraLarge,
              boxShadow: AppShadows.neonShadow,
            ),
            child: user.avatarUrl != null
                ? ClipRRect(
                    borderRadius: AppBorderRadius.extraLarge,
                    child: Image.network(
                      user.avatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.person,
                          size: 60,
                          color: AppColors.textPrimary,
                        );
                      },
                    ),
                  )
                : const Icon(
                    Icons.person,
                    size: 60,
                    color: AppColors.textPrimary,
                  ),
          ),
          
          const SizedBox(height: AppSpacing.md),
          
          // User Name
          Text(
            user.name ?? 'User',
            style: AppTextStyles.heading2,
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppSpacing.xs),
          
          // User Email
          Text(
            user.email,
            style: AppTextStyles.body2.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          
          if (user.isAdmin) ...[
            const SizedBox(height: AppSpacing.sm),
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
              child: Text(
                'ADMIN',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUserStats() {
    return Consumer<SongsProvider>(
      builder: (context, songsProvider, child) {
        return Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: AppBorderRadius.medium,
            boxShadow: AppShadows.cardShadow,
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  icon: Icons.favorite,
                  label: 'Favorites',
                  value: '${songsProvider.favorites.length}',
                  color: AppColors.error,
                ),
              ),
              Container(
                width: 1,
                height: 50,
                color: AppColors.textMuted.withOpacity(0.3),
              ),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.download,
                  label: 'Downloads',
                  value: '${songsProvider.downloads.length}',
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 30,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          value,
          style: AppTextStyles.heading3.copyWith(
            color: color,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.body2.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileActions(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: AppBorderRadius.medium,
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        children: [
          _buildActionItem(
            icon: Icons.settings,
            title: 'Settings',
            subtitle: 'App preferences and configuration',
            onTap: () {
              // TODO: Implement settings screen
            },
          ),
          _buildDivider(),
          _buildActionItem(
            icon: Icons.help_outline,
            title: 'Help & Support',
            subtitle: 'Get help and contact support',
            onTap: () {
              // TODO: Implement help screen
            },
          ),
          _buildDivider(),
          _buildActionItem(
            icon: Icons.info_outline,
            title: 'About',
            subtitle: 'App version and information',
            onTap: () {
              // TODO: Implement about screen
            },
          ),
          _buildDivider(),
          _buildActionItem(
            icon: Icons.logout,
            title: 'Sign Out',
            subtitle: 'Sign out of your account',
            onTap: () => _showSignOutDialog(context),
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isDestructive
              ? AppColors.error.withOpacity(0.2)
              : AppColors.primary.withOpacity(0.2),
          borderRadius: AppBorderRadius.medium,
        ),
        child: Icon(
          icon,
          color: isDestructive ? AppColors.error : AppColors.primary,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: AppTextStyles.body1.copyWith(
          color: isDestructive ? AppColors.error : AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.body2.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: AppColors.textSecondary,
        size: 16,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: AppColors.textMuted.withOpacity(0.3),
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
    );
  }

  Widget _buildAppInfo() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: AppBorderRadius.medium,
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        children: [
          Text(
            'ARCADIA MUSIC',
            style: AppTextStyles.heading3.copyWith(
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Version 1.0.0',
            style: AppTextStyles.body2.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Futuristic Music Experience',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: AppBorderRadius.medium,
        ),
        title: Text(
          'Sign Out',
          style: AppTextStyles.heading3,
        ),
        content: Text(
          'Are you sure you want to sign out?',
          style: AppTextStyles.body1,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTextStyles.body1.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _signOut(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.textPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: AppBorderRadius.small,
              ),
            ),
            child: Text(
              'Sign Out',
              style: AppTextStyles.button,
            ),
          ),
        ],
      ),
    );
  }

  void _signOut(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.signOut();
    
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }
} 