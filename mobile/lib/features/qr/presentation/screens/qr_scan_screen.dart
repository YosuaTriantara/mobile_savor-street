import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/base_button.dart';
import '../../data/qr_token_parser.dart';
import '../providers/qr_validation_provider.dart';
import '../widgets/manual_token_sheet.dart';
import '../widgets/qr_scanner_overlay.dart';

/// Entry point aplikasi: customer scan QR di meja untuk membuka session.
/// Alur: scan → parse token → validasi ke backend → simpan session → /menu.
class QrScanScreen extends ConsumerStatefulWidget {
  const QrScanScreen({super.key});

  @override
  ConsumerState<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends ConsumerState<QrScanScreen> {
  final MobileScannerController _controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
  );

  bool _isHandling = false;
  DateTime? _lastInvalidQrAt;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_isHandling) return;
    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;
    final rawValue = barcodes.first.rawValue;
    if (rawValue == null || rawValue.isEmpty) return;
    await _handleRawValue(rawValue);
  }

  Future<void> _handleRawValue(String rawValue) async {
    if (_isHandling) return;

    final notifier = ref.read(qrValidationProvider.notifier);
    final token = extractQrToken(rawValue);

    if (token == null) {
      // Kamera terus berjalan dan QR yang sama terdeteksi tiap frame,
      // jadi pesan "QR tidak dikenali" cukup di-refresh tiap 2 detik.
      final now = DateTime.now();
      if (_lastInvalidQrAt == null ||
          now.difference(_lastInvalidQrAt!) > const Duration(seconds: 2)) {
        _lastInvalidQrAt = now;
        notifier.markInvalidQr();
      }
      return;
    }

    _isHandling = true;
    await _controller.stop();
    final success = await notifier.validate(token);
    if (!mounted) return;

    if (success) {
      context.go(AppRoutes.menu);
    } else {
      await _controller.start();
      _isHandling = false;
    }
  }

  Future<void> _openManualInput() async {
    final token = await showManualTokenSheet(context);
    if (token == null || token.isEmpty || !mounted) return;
    ref.read(qrValidationProvider.notifier).reset();
    await _handleRawValue(token);
  }

  @override
  Widget build(BuildContext context) {
    final validationState = ref.watch(qrValidationProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
            errorBuilder: (context, error) => _CameraErrorView(
              onManualInput: _openManualInput,
            ),
          ),
          const QrScannerOverlay(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  Text('Savor Street', style: AppTextStyles.brandTitle),
                  const SizedBox(height: 8),
                  Text(
                    'Scan QR code di meja Anda untuk mulai memesan',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body.copyWith(color: Colors.white),
                  ),
                  const Spacer(),
                  if (validationState.errorMessage != null) ...[
                    _ErrorBanner(message: validationState.errorMessage!),
                    const SizedBox(height: 12),
                  ],
                  BaseButton(
                    label: 'Masukkan Token Manual',
                    icon: Icons.keyboard_alt_outlined,
                    onPressed:
                        validationState.isValidating ? null : _openManualInput,
                  ),
                ],
              ),
            ),
          ),
          if (validationState.isValidating)
            Container(
              color: Colors.black.withValues(alpha: 0.6),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(
                      color: AppColors.badgeGold,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Memvalidasi meja...',
                      style:
                          AppTextStyles.body.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;

  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.danger,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.body.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tampil saat kamera tidak tersedia (permission ditolak / emulator).
class _CameraErrorView extends StatelessWidget {
  final VoidCallback onManualInput;

  const _CameraErrorView({required this.onManualInput});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.no_photography_outlined,
                color: Colors.white54, size: 56),
            const SizedBox(height: 16),
            Text(
              'Kamera tidak tersedia.\n'
              'Izinkan akses kamera di pengaturan, atau masukkan token meja '
              'secara manual.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
