import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/image_url_helper.dart';
import '../../../../shared/helpers/price_formatter.dart';
import '../../../../shared/widgets/base_button.dart';
import '../../../../shared/widgets/error_state_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../providers/menu_detail_provider.dart';

class MenuDetailPage extends ConsumerWidget {
  final int idMenu;

  const MenuDetailPage({super.key, required this.idMenu});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(menuDetailProvider(idMenu));

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        backgroundColor: AppColors.creamBackground,
        elevation: 0,
        title: Text('Detail Menu', style: AppTextStyles.screenTitle),
      ),
      body: SafeArea(child: _buildBody(context, ref, detailState)),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    MenuDetailState state,
  ) {
    if (state.isLoading && state.menu == null) {
      return const LoadingWidget(message: 'Memuat detail menu...');
    }

    if (state.error != null && state.menu == null) {
      return ErrorStateWidget(
        message: state.error!,
        onRetry: () => ref.read(menuDetailProvider(idMenu).notifier).retry(idMenu),
      );
    }

    final menu = state.menu!;
    final imageUrl = (menu.gambarMenu != null && menu.gambarMenu!.isNotEmpty)
        ? ImageUrlHelper.build(menu.gambarMenu!)
        : null;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: AspectRatio(
                aspectRatio: 1.4,
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
            ),
            const SizedBox(height: 20),
            Text(menu.namaMenu, style: AppTextStyles.screenTitle),
            const SizedBox(height: 8),
            Text(
              PriceFormatter.formatWithPrefix(menu.harga),
              style: AppTextStyles.price.copyWith(
                fontSize: 20,
                color: AppColors.primaryGreen,
              ),
            ),
            if (menu.deskripsi != null && menu.deskripsi!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text('Deskripsi', style: AppTextStyles.sectionTitle),
              const SizedBox(height: 6),
              Text(menu.deskripsi!, style: AppTextStyles.body),
            ],
            if (!menu.isAvailable) ...[
              const SizedBox(height: 16),
              Text(
                'Menu ini sedang habis.',
                style: AppTextStyles.body.copyWith(color: AppColors.danger),
              ),
            ],
            const SizedBox(height: 28),
            BaseButton(
              label: 'Pilih Kustomisasi',
              onPressed: menu.isAvailable
                  ? () => context.pushNamed(
                        AppRoutes.customizationName,
                        pathParameters: {'idMenu': '${menu.idMenu}'},
                      )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagePlaceholder() => Container(
        color: AppColors.creamHeader,
        alignment: Alignment.center,
        child: const Icon(Icons.restaurant_menu, color: AppColors.gold, size: 48),
      );
}