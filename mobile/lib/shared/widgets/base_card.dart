import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Card putih rounded + shadow halus, sesuai pola yang dipakai di
/// Invoice box (cart/order/invoice screen).
class BaseCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const BaseCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );

    if (onTap == null) return card;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: InkWell(onTap: onTap, child: card),
    );
  }
}