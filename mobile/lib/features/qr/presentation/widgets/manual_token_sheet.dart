import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/base_button.dart';
import '../../../../shared/widgets/base_text_field.dart';

/// Bottom sheet input token manual — fallback saat kamera tidak tersedia
/// (mis. emulator) atau QR sulit terbaca. Mengembalikan token yang diketik
/// lewat Navigator.pop, atau null jika dibatalkan.
Future<String?> showManualTokenSheet(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.creamBackground,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => const _ManualTokenSheet(),
  );
}

class _ManualTokenSheet extends StatefulWidget {
  const _ManualTokenSheet();

  @override
  State<_ManualTokenSheet> createState() => _ManualTokenSheetState();
}

class _ManualTokenSheetState extends State<_ManualTokenSheet> {
  final TextEditingController _controller = TextEditingController();
  bool _canSubmit = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final token = _controller.text.trim();
    if (token.isEmpty) return;
    Navigator.of(context).pop(token);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Masukkan Token Meja', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 8),
          Text(
            'Token tertera di bawah QR code pada meja Anda, '
            'atau minta bantuan staff restoran.',
            style: AppTextStyles.body,
          ),
          const SizedBox(height: 16),
          BaseTextField(
            controller: _controller,
            hintText: 'Contoh: bran9FoHykTngrx1o6he...',
            onChanged: (value) =>
                setState(() => _canSubmit = value.trim().isNotEmpty),
          ),
          const SizedBox(height: 16),
          BaseButton(
            label: 'Validasi Token',
            onPressed: _canSubmit ? _submit : null,
          ),
        ],
      ),
    );
  }
}
