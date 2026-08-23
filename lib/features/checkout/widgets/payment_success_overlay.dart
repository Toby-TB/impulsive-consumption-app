import 'dart:math';

import 'package:flutter/material.dart';

/// 支付成功全屏动效：圆环扩散 + 对勾描边 + 粒子迸发。
/// 播放完毕回调 [onFinished]（约 1.6s）。
void showPaymentSuccess(
  BuildContext context, {
  required VoidCallback onFinished,
}) {
  final controller =
      AnimationController(vsync: Navigator.of(context), duration: const Duration(milliseconds: 1600));
  late final OverlayEntry entry;

  entry = OverlayEntry(
    builder: (_) => _SuccessOverlay(
      controller: controller,
      onDismissed: () {
        if (entry.mounted) entry.remove();
        controller.dispose();
        onFinished();
      },
    ),
  );

  Overlay.of(context).insert(entry);
  controller.forward();
}

class _SuccessOverlay extends StatelessWidget {
  final AnimationController controller;
  final VoidCallback onDismissed;

  const _SuccessOverlay({
    required this.controller,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: Center(
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            if (controller.status == AnimationStatus.completed) {
              WidgetsBinding.instance.addPostFrameCallback((_) => onDismissed());
            }
            return CustomPaint(
              painter: _SuccessPainter(progress: controller.value),
              size: const Size(160, 160),
            );
          },
        ),
      ),
    );
  }
}

class _SuccessPainter extends CustomPainter {
  final double progress;

  _SuccessPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final t = progress.clamp(0.0, 1.0);

    // 背景圆：先弹性放大
    final circleT = (t / 0.4).clamp(0.0, 1.0);
    final eased = Curves.easeOutBack.transform(circleT);
    final radius = 56.0 * eased;
    canvas.drawCircle(center, radius, Paint()..color = const Color(0xFF2ECC71));

    // 对勾描边：0.35~0.75 区间绘制
    if (t > 0.35) {
      final checkT = ((t - 0.35) / 0.4).clamp(0.0, 1.0);
      final checkPath = Path()
        ..moveTo(center.dx - 24, center.dy + 2)
        ..lineTo(center.dx - 6, center.dy + 20)
        ..lineTo(center.dx + 26, center.dy - 18);

      final metric = checkPath.computeMetrics().first;
      final partial = metric.extractPath(0, metric.length * checkT);
      canvas.drawPath(
        partial,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }

    // 粒子：0.5 之后迸发
    if (t > 0.5) {
      final particleT = ((t - 0.5) / 0.5).clamp(0.0, 1.0);
      final rng = Random(42);
      for (var i = 0; i < 24; i++) {
        final angle = rng.nextDouble() * 2 * pi;
        final dist = 70 + rng.nextDouble() * 40;
        final p = center +
            Offset(cos(angle), sin(angle)) * dist * Curves.easeOut.transform(particleT);
        final opacity = (1 - particleT).clamp(0.0, 1.0);
        canvas.drawCircle(
          p,
          3 * (1 - particleT * 0.6),
          Paint()..color = const Color(0xFF2ECC71).withValues(alpha: opacity),
        );
      }
    }
  }

  @override
  bool shouldRepaint(_SuccessPainter oldDelegate) => oldDelegate.progress != progress;
}
