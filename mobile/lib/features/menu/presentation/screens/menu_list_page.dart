import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/error_state_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../providers/category_provider.dart';
import '../providers/menu_provider.dart';
import '../widgets/category_chip_list.dart';
import '../widgets/menu_card.dart';
import '../widgets/menu_search_bar.dart';

class MenuListPage extends ConsumerWidget {
  const MenuListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartSummaryProvider).totalItem;

    // Tampilkan error fetch menu (mis. gagal search/filter) lewat snackbar,
    // supaya grid yang sudah terisi data lama tidak ikut hilang/replaced
    // oleh full-screen error state (lihat _MenuGridSection).
    ref.listen<MenuState>(menuProvider, (previous, next) {
      if (next.error != null &&
          next.error != previous?.error &&
          next.menus.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!)),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        backgroundColor: AppColors.creamBackground,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('Menu', style: AppTextStyles.screenTitle),
        actions: [
          _CartAction(
            count: cartCount,
            onTap: () => context.pushNamed(AppRoutes.cartName),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              MenuSearchBar(
                onSearch: (query) =>
                    ref.read(menuProvider.notifier).search(query),
              ),
              const SizedBox(height: 16),
              const _CategorySection(),
              const SizedBox(height: 16),
              const Expanded(child: _MenuGridSection()),
            ],
          ),
        ),
      ),
    );
  }
}

class _CartAction extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const _CartAction({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(Icons.shopping_cart_outlined, color: AppColors.textPrimary),
          if (count > 0)
            Positioned(
              right: -4,
              top: -4,
              child: Container(
                padding: const EdgeInsets.all(3),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                decoration: const BoxDecoration(
                  color: AppColors.badgeGold,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$count',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Chip kategori, sumber data dari `categoryProvider` (`CategoryState`
/// biasa — bukan `AsyncValue`, jadi loading/error dicek manual dari field
/// `isLoading` / `error`).
class _CategorySection extends ConsumerWidget {
  const _CategorySection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryState = ref.watch(categoryProvider);

    if (categoryState.isLoading && categoryState.categories.isEmpty) {
      return const SizedBox(
        height: 40,
        child: Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primaryGreen,
            ),
          ),
        ),
      );
    }

    if (categoryState.error != null && categoryState.categories.isEmpty) {
      return SizedBox(
        height: 40,
        child: Center(
          child: GestureDetector(
            // CategoryNotifier tidak punya method retry publik, jadi
            // provider-nya di-invalidate supaya build() (dan fetch
            // kategorinya) berjalan ulang dari awal.
            onTap: () => ref.invalidate(categoryProvider),
            child: Text(
              '${categoryState.error} Tap untuk coba lagi.',
              style: AppTextStyles.body.copyWith(color: AppColors.danger),
            ),
          ),
        ),
      );
    }

    return CategoryChipList(
      categories: categoryState.categories,
      selected: categoryState.selected,
      // selectCategory() di CategoryNotifier SUDAH memanggil
      // menuProvider.notifier.filterByCategory() di dalamnya sendiri —
      // jangan dipanggil manual lagi di sini, nanti double-fetch.
      onSelected: (category) =>
          ref.read(categoryProvider.notifier).selectCategory(category),
    );
  }
}

/// Grid menu, sumber data dari `menuProvider` (`MenuState` biasa).
class _MenuGridSection extends ConsumerWidget {
  const _MenuGridSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuState = ref.watch(menuProvider);

    if (menuState.isLoading && menuState.menus.isEmpty) {
      return const LoadingWidget(message: 'Memuat menu...');
    }

    if (menuState.error != null && menuState.menus.isEmpty) {
      return ErrorStateWidget(
        message: menuState.error!,
        // Retry pakai search() dengan query saat ini (bisa string kosong)
        // supaya kategori aktif di MenuState tidak berubah.
        onRetry: () =>
            ref.read(menuProvider.notifier).search(menuState.searchQuery),
      );
    }

    if (menuState.menus.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.ramen_dining_outlined,
        title: 'Menu tidak ditemukan',
        subtitle: 'Coba kategori atau kata kunci lain.',
      );
    }

    // Data sudah ada (baik dari load sukses maupun data lama saat refresh
    // berikutnya sedang isLoading/error) -> tetap tampilkan grid, biar
    // tidak "berkedip" ke loading/error setiap kali user ganti filter.
    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: menuState.menus.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) {
        final menu = menuState.menus[index];
        return MenuCard(
          menu: menu,
          onTap: () => context.pushNamed(
            AppRoutes.menuDetailName,
            pathParameters: {'idMenu': '${menu.idMenu}'},
          ),
        );
      },
    );
  }
}