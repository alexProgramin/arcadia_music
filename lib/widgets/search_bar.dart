import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(String) onChanged;
  final String? hintText;

  const CustomSearchBar({
    super.key,
    required this.onChanged,
    this.hintText,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _controller = TextEditingController();
  bool _isFocused = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: _isFocused 
            ? AppColors.cardBackground.withOpacity(0.8)
            : AppColors.cardBackground,
        borderRadius: AppBorderRadius.medium,
        border: Border.all(
          color: _isFocused ? AppColors.primary : Colors.transparent,
          width: 2,
        ),
        boxShadow: _isFocused 
            ? AppShadows.neonShadow
            : AppShadows.cardShadow,
      ),
      child: Focus(
        onFocusChange: (hasFocus) {
          setState(() {
            _isFocused = hasFocus;
          });
        },
        child: TextField(
          controller: _controller,
          onChanged: widget.onChanged,
          style: AppTextStyles.body1,
          decoration: InputDecoration(
            hintText: widget.hintText ?? 'Search songs...',
            hintStyle: AppTextStyles.body2.copyWith(
              color: AppColors.textMuted,
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: AppColors.primary,
            ),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(
                      Icons.clear,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      _controller.clear();
                      widget.onChanged('');
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
          ),
        ),
      ),
    );
  }
} 