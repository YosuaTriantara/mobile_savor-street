import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Overlay gelap dengan lubang kotak di tengah sebagai area scan,
/// plus aksen sudut emas mengikuti tema aplikasi.
class QrScannerOverlay extends StatelessWidget {
  final double scanAreaSize;

  const QrScannerOverlay({super.key, this.scanAreaSize = 260});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        size: Size.infinite,
        painter: _OverlayPainter(scanAreaSize),
      ),
    );
  }
}

class _OverlayPainter extends CustomPainter {
  final double scanAreaSize;

  _OverlayPainter(this.scanAreaSize);

  @override
  void paint(Canvas canvas, Size size) {
    final scanRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: scanAreaSize,
      height: scanAreaSize,
    );
    final scanRRect = RRect.fromRectAndRadius(
      scanRect,
      const Radius.circular(24),
    );

    final background = Path()..addRect(Offset.zero & size);
    final hole = Path()..addRRect(scanRRect);
    final overlay =
        Path.combine(PathOperation.difference, background, hole);
    canvas.drawPath(
      overlay,
      Paint()..color = Colors.black.withValues(alpha: 0.55),
    );

    final cornerPaint = Paint()
      ..color = AppColors.badgeGold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    const cornerLength = 28.0;

    void drawCorner(Offset corner, double dx, double dy) {
      canvas.drawLine(corner, corner.translate(dx, 0), cornerPaint);
      canvas.drawLine(corner, corner.translate(0, dy), cornerPaint);
    }

    drawCorner(scanRect.topLeft, cornerLength, cornerLength);
    drawCorner(scanRect.topRight, -cornerLength, cornerLength);
    drawCorner(scanRect.bottomLeft, cornerLength, -cornerLength);
    drawCorner(scanRect.bottomRight, -cornerLength, -cornerLength);
  }

  @override
  bool shouldRepaint(_OverlayPainter oldDelegate) =>
      oldDelegate.scanAreaSize != scanAreaSize;
}
