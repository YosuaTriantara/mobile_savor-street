import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Search bar dengan debounce internal.
///
/// Debounce SENGAJA ditaruh di widget ini (bukan di `menuProvider`), sesuai
/// keputusan tim: provider hanya fetch saat method-nya dipanggil secara
/// eksplisit, jadi widget inilah yang bertanggung jawab menahan ketikan
/// user sebelum benar-benar memicu request ke API.
class MenuSearchBar extends StatefulWidget {
  /// Dipanggil setelah user berhenti mengetik selama [debounceDuration].
  final ValueChanged<String> onSearch;
  final String hintText;
  final Duration debounceDuration;

  const MenuSearchBar({
    super.key,
    required this.onSearch,
    this.hintText = 'Cari menu favoritmu...',
    this.debounceDuration = const Duration(milliseconds: 400),
  });

  @override
  State<MenuSearchBar> createState() => _MenuSearchBarState();
}

class _MenuSearchBarState extends State<MenuSearchBar> {
  final _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() {}); // agar tombol clear muncul/hilang sesuai isi field
    _debounce?.cancel();
    _debounce = Timer(widget.debounceDuration, () {
      widget.onSearch(value.trim());
    });
  }

  void _clear() {
    _debounce?.cancel();
    _controller.clear();
    widget.onSearch('');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: _onChanged,
      textInputAction: TextInputAction.search,
      style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: AppTextStyles.body.copyWith(
          color: AppColors.textSecondary.withValues(alpha: 0.7),
        ),
        prefixIcon: const Icon(Icons.search, color: AppColors.primaryGreen),
        suffixIcon: _controller.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.close, color: AppColors.textSecondary),
                onPressed: _clear,
              ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
        ),
      ),
    );
  }
}