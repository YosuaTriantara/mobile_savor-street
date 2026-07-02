import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/image_url_helper.dart';
import '../../../../shared/helpers/price_formatter.dart';
import '../../../../shared/widgets/quantity_stepper.dart';
import '../../domain/entities/cart_item.dart';

class CartItemTile extends StatelessWidget {
  final CartItem item;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onEdit;

  const CartItemTile({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        item.menu.gambarMenu != null ? ImageUrlHelper.build(item.menu.gambarMenu!) : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.menu.namaMenu, style: AppTextStyles.itemName),
                if (item.customLabel.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text('Custom : ${item.customLabel}', style: AppTextStyles.body),
                ],
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: onEdit,
                  child: Text('Edit', style: AppTextStyles.link),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      PriceFormatter.formatWithPrefix(item.subtotal),
                      style: AppTextStyles.price,
                    ),
                    QuantityStepper(
                      quantity: item.jumlah,
                      onChanged: onQuantityChanged,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => _placeholder(),
                  )
                : _placeholder(),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() => Container(
        width: 64,
        height: 64,
        color: AppColors.creamHeader,
        child: const Icon(Icons.restaurant, color: AppColors.gold),
      );
}
