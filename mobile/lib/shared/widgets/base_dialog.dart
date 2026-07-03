import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'base_button.dart';

/// Dialog standar aplikasi — rounded, konsisten dengan card style.
/// Pakai `BaseDialog.show(...)` daripada `showDialog` manual.
class BaseDialog extends StatelessWidget {
  final String title;
  final String? message;
  final Widget? content;
  final String confirmLabel;
  final String? cancelLabel;
  final VoidCallback? onConfirm;

  const BaseDialog({
    super.key,
    required this.title,
    this.message,
    this.content,
    this.confirmLabel = 'OK',
    this.cancelLabel,
    this.onConfirm,
  });

  static Future<void> show({
    required BuildContext context,
    required String title,
    String? message,
    Widget? content,
    String confirmLabel = 'OK',
    String? cancelLabel,
    VoidCallback? onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (_) => BaseDialog(
        title: title,
        message: message,
        content: content,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.sectionTitle),
            if (message != null) ...[
              const SizedBox(height: 12),
              Text(message!, style: AppTextStyles.body),
            ],
            if (content != null) ...[
              const SizedBox(height: 12),
              content!,
            ],
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (cancelLabel != null)
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      cancelLabel!,
                      style: AppTextStyles.link
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                const SizedBox(width: 8),
                BaseButton(
                  label: confirmLabel,
                  isFullWidth: false,
                  onPressed: () {
                    Navigator.of(context).pop();
                    onConfirm?.call();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}