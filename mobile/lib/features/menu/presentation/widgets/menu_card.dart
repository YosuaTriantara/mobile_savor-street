import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/image_url_helper.dart';
import '../../../../shared/helpers/price_formatter.dart';
import '../../domain/entities/menu_entity.dart';

/// Card menu untuk grid di [MenuListPage].
///
/// Field yang dipakai mengikuti kontrak `MenuEntity` sesuai
/// `docs/api-contract/menu-api.md` (idMenu, namaMenu, harga, kategori,
/// gambarMenu, status) — sama seperti stub sementara yang sebelumnya ada
/// di `features/cart/domain/entities/menu_entity.dart`.
class MenuCard extends StatelessWidget {
  final MenuEntity menu;
  final VoidCallback onTap;

  const MenuCard({super.key, required this.menu, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final imageUrl = (menu.gambarMenu != null && menu.gambarMenu!.isNotEmpty)
        ? ImageUrlHelper.build(menu.gambarMenu!)
        : null;
    final isAvailable = menu.status == 'available';

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Material(
        color: AppColors.surface,
        child: InkWell(
          onTap: isAvailable ? onTap : null,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AspectRatio(
                  aspectRatio: 1.2,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(18),
                        ),
                        child: imageUrl != null
                            ? CachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    Container(color: AppColors.creamHeader),
                                errorWidget: (context, url, error) =>
                                    _imagePlaceholder(),
                              )
                            : _imagePlaceholder(),
                      ),
                      if (!isAvailable)
                        Container(
                          color: Colors.black.withValues(alpha: 0.45),
                          alignment: Alignment.center,
                          child: Text(
                            'Habis',
                            style:
                                AppTextStyles.buttonLabel.copyWith(fontSize: 13),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        menu.namaMenu,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.itemName.copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        PriceFormatter.formatWithPrefix(menu.harga),
                        style: AppTextStyles.price.copyWith(
                          fontSize: 14,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _imagePlaceholder() => Container(
        color: AppColors.creamHeader,
        alignment: Alignment.center,
        child: const Icon(
          Icons.restaurant_menu,
          color: AppColors.gold,
          size: 32,
        ),
      );
}