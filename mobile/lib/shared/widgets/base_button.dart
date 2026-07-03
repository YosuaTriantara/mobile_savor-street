import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

enum BaseButtonVariant { primary, secondary, danger }

/// Tombol pill standar aplikasi. Contoh pemakaian: "Add to cart", "Order",
/// "Order Again" (primary) dan "Request Bill" (secondary).
class BaseButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final BaseButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;

  const BaseButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = BaseButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;
    final Color background = switch (variant) {
      BaseButtonVariant.primary => AppColors.primaryGreen,
      BaseButtonVariant.secondary => Colors.transparent,
      BaseButtonVariant.danger => AppColors.danger,
    };
    final Color foreground = switch (variant) {
      BaseButtonVariant.primary => Colors.white,
      BaseButtonVariant.secondary => AppColors.primaryGreen,
      BaseButtonVariant.danger => Colors.white,
    };
    final BorderSide? border = variant == BaseButtonVariant.secondary
        ? const BorderSide(color: AppColors.primaryGreen, width: 1.5)
        : null;

    final child = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: foreground,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: foreground),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: AppTextStyles.buttonLabel.copyWith(color: foreground),
              ),
            ],
          );

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          disabledBackgroundColor: background.withValues(alpha: 0.4),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: StadiumBorder(side: border ?? BorderSide.none),
        ),
        child: child,
      ),
    );
  }
}