import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'menu_provider.dart';

class CategoryState {
  final List<String> categories;
  final String? selected;
  final bool isLoading;
  final String? error;

  const CategoryState({
    this.categories = const [],
    this.selected,
    this.isLoading = false,
    this.error,
  });
}

/// Mengelola daftar kategori & kategori aktif untuk chip filter di
/// Menu List Screen (Gambar 4 & 5).
///
/// Begitu daftar kategori berhasil diambil, kategori pertama otomatis
/// dipilih sebagai default (mengikuti mockup, di mana salah satu chip
/// tampak aktif sejak layar pertama dibuka) — dan itulah yang memicu
/// pemuatan awal MenuProvider.
class CategoryNotifier extends Notifier<CategoryState> {
  @override
  CategoryState build() {
    Future.microtask(_fetchCategories);
    return const CategoryState(isLoading: true);
  }

  Future<void> _fetchCategories() async {
    state = CategoryState(
      categories: state.categories,
      selected: state.selected,
      isLoading: true,
    );
    try {
      final repo = ref.read(menuRepositoryProvider);
      final categories = await repo.getCategories();
      final selected =
          state.selected ?? (categories.isNotEmpty ? categories.first : null);
      state = CategoryState(categories: categories, selected: selected);

      if (selected != null) {
        await ref.read(menuProvider.notifier).filterByCategory(selected);
      }
    } catch (_) {
      state = CategoryState(
        categories: state.categories,
        selected: state.selected,
        error: 'Gagal memuat kategori.',
      );
    }
  }

  /// Dipanggil saat user tap salah satu chip kategori.
  void selectCategory(String category) {
    if (category == state.selected) return;
    state = CategoryState(categories: state.categories, selected: category);
    ref.read(menuProvider.notifier).filterByCategory(category);
  }
}

final categoryProvider =
    NotifierProvider<CategoryNotifier, CategoryState>(CategoryNotifier.new);