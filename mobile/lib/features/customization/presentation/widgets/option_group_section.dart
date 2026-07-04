import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/helpers/price_formatter.dart';
import '../../domain/entities/opsi_entity.dart';
import '../../domain/entities/opsi_group_entity.dart';

/// Render satu grup opsi kustomisasi.
///
/// `group.multiple == true` (topping) -> checkbox, bisa pilih lebih dari
/// satu. Selain itu -> radio, single-select.
class OptionGroupSection extends StatelessWidget {
  final OpsiGroupEntity group;
  final List<OpsiEntity> selected;
  final ValueChanged<OpsiEntity> onToggle;

  const OptionGroupSection({
    super.key,
    required this.group,
    required this.selected,
    required this.onToggle,
  });

  bool _isSelected(OpsiEntity opsi) =>
      selected.any((o) => o.idOpsi == opsi.idOpsi);

  @override
  Widget build(BuildContext context) {
    final showRequiredWarning = group.required && selected.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(group.grupOpsi, style: AppTextStyles.sectionTitle),
            const SizedBox(width: 8),
            if (group.required)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: showRequiredWarning
                      ? AppColors.danger.withValues(alpha: 0.1)
                      : AppColors.primaryGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Wajib pilih',
                  style: AppTextStyles.body.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: showRequiredWarning
                        ? AppColors.danger
                        : AppColors.primaryGreen,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        ...group.options.map((opsi) {
          final isSelected = _isSelected(opsi);
          return InkWell(
            onTap: () => onToggle(opsi),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Icon(
                    group.multiple
                        ? (isSelected
                            ? Icons.check_box
                            : Icons.check_box_outline_blank)
                        : (isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked),
                    color: isSelected
                        ? AppColors.primaryGreen
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(opsi.namaOpsi, style: AppTextStyles.body.copyWith(
                      color: AppColors.textPrimary,
                    )),
                  ),
                  if (opsi.hargaTambahan > 0)
                    Text(
                      '+${PriceFormatter.formatWithPrefix(opsi.hargaTambahan)}',
                      style: AppTextStyles.body,
                    ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 12),
      ],
    );
  }
}