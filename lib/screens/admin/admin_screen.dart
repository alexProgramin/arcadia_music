import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/songs_provider.dart';
import '../../models/song.dart';
import '../../services/supabase_service.dart';
import '../../utils/constants.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _genreController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _audioUrlController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _genreController.dispose();
    _imageUrlController.dispose();
    _audioUrlController.dispose();
    super.dispose();
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
              
              // Form
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Title Field
                        _buildTextField(
                          controller: _titleController,
                          label: 'Song Title',
                          icon: Icons.music_note,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter song title';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: AppSpacing.md),
                        
                        // Description Field
                        _buildTextField(
                          controller: _descriptionController,
                          label: 'Description',
                          icon: Icons.description,
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter description';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: AppSpacing.md),
                        
                        // Genre Field
                        _buildTextField(
                          controller: _genreController,
                          label: 'Genre',
                          icon: Icons.category,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter genre';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: AppSpacing.md),
                        
                        // Image URL Field
                        _buildTextField(
                          controller: _imageUrlController,
                          label: 'Image URL',
                          icon: Icons.image,
                                                     validator: (value) {
                             if (value == null || value.isEmpty) {
                               return 'Please enter image URL';
                             }
                             final uri = Uri.tryParse(value);
                             if (uri == null || !uri.hasAbsolutePath) {
                               return 'Please enter a valid URL';
                             }
                             return null;
                           },
                        ),
                        
                        const SizedBox(height: AppSpacing.md),
                        
                        // Audio URL Field
                        _buildTextField(
                          controller: _audioUrlController,
                          label: 'Audio URL',
                          icon: Icons.audiotrack,
                                                     validator: (value) {
                             if (value == null || value.isEmpty) {
                               return 'Please enter audio URL';
                             }
                             final uri = Uri.tryParse(value);
                             if (uri == null || !uri.hasAbsolutePath) {
                               return 'Please enter a valid URL';
                             }
                             return null;
                           },
                        ),
                        
                        const SizedBox(height: AppSpacing.lg),
                        
                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: AppColors.textPrimary,
                              padding: const EdgeInsets.symmetric(
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
                                vertical: AppSpacing.md,
                              ),
                              child: Center(
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            AppColors.textPrimary,
                                          ),
                                        ),
                                      )
                                    : Text(
                                        'ADD SONG',
                                        style: AppTextStyles.button,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
              Icons.admin_panel_settings,
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
                  'ADMIN PANEL',
                  style: AppTextStyles.heading3.copyWith(
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  'Add new songs to the library',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: AppBorderRadius.medium,
        boxShadow: AppShadows.cardShadow,
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: AppTextStyles.body1,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTextStyles.body2,
          prefixIcon: Icon(
            icon,
            color: AppColors.primary,
          ),
          border: OutlineInputBorder(
            borderRadius: AppBorderRadius.medium,
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: AppColors.cardBackground,
        ),
        validator: validator,
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final song = Song(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          genre: _genreController.text.trim(),
          imageUrl: _imageUrlController.text.trim(),
          audioUrl: _audioUrlController.text.trim(),
          createdAt: DateTime.now(),
        );

        // Add song to Supabase
        await SupabaseService.addSong(song);

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Song added successfully!',
                style: AppTextStyles.body1,
              ),
              backgroundColor: AppColors.success,
            ),
          );

          // Clear form
          _formKey.currentState!.reset();
          _titleController.clear();
          _descriptionController.clear();
          _genreController.clear();
          _imageUrlController.clear();
          _audioUrlController.clear();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Error adding song: $e',
                style: AppTextStyles.body1,
              ),
              backgroundColor: AppColors.error,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }
} 