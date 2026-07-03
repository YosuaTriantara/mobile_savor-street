import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Baris chip kategori yang bisa di-scroll horizontal.
///
/// Widget ini generic dan tidak tahu apa-apa soal provider — cukup dikasih
/// [categories] + [selected], lalu panggil [onSelected] saat user tap salah
/// satu chip. Pemanggilnya (MenuListPage) yang bertanggung jawab
/// menghubungkan ke `categoryProvider` / `menuProvider`.
class CategoryChipList extends StatelessWidget {
  final List<String> categories;
  final String? selected;
  final ValueChanged<String> onSelected;

  const CategoryChipList({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selected;

          return ChoiceChip(
            label: Text(category),
            selected: isSelected,
            onSelected: (_) => onSelected(category),
            showCheckmark: false,
            labelStyle: AppTextStyles.body.copyWith(
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
            backgroundColor: AppColors.surface,
            selectedColor: AppColors.primaryGreen,
            side: BorderSide(
              color: isSelected ? AppColors.primaryGreen : AppColors.border,
            ),
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          );
        },
      ),
    );
  }
}