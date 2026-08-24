import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 特效类型。
enum Sfx { pop, coin, crit, combo, levelup, gacha }

/// 统一"爽感"特效入口：购物逻辑只调用这里，不直接触碰动画/音频/触感。
///
/// - 音效：预加载 AudioPool，低延迟播放，可全局静音
/// - 触感：移动端轻/中/重三档，桌面/网页自动忽略
/// - 视觉：金币爆发 / 连击浮标 / 暴击闪屏（Overlay 实现）
abstract final class JuiceFX {
  static final Map<Sfx, AudioPool> _pools = {};
  static bool sfxEnabled = true;
  static bool _hapticsEnabled = true;

  /// 应用启动时预加载全部音效。
  static Future<void> warmUp() async {
    for (final s in Sfx.values) {
      try {
        _pools[s] = await AudioPool.create(
          source: AssetSource('audio/${s.name}.wav'),
          maxPlayers: 3,
        );
      } catch (_) {
        // Web 或资源缺失时静默降级为纯视觉反馈
      }
    }
  }

  static void setSfxEnabled(bool v) {
    sfxEnabled = v;
    if (!v) HapticFeedback.selectionClick();
  }

  static void setHapticsEnabled(bool v) => _hapticsEnabled = v;

  static void play(Sfx type, {double volume = 0.4}) {
    if (!sfxEnabled) return;
    _pools[type]?.start(volume: volume);
  }

  static void haptic(HapticLevel level) {
    if (!_hapticsEnabled) return;
    switch (level) {
      case HapticLevel.light:
        HapticFeedback.selectionClick();
      case HapticLevel.medium:
        HapticFeedback.mediumImpact();
      case HapticLevel.heavy:
        HapticFeedback.heavyImpact();
    }
  }

  /// 金币爆发：从 [anchor]（屏幕坐标，可空=屏幕中心）迸发 N 枚金币。
  static void coinBurst(
    BuildContext context, {
    Offset? anchor,
    int count = 14,
    Color color = const Color(0xFFFFC93C),
  }) {
    _pushOverlay(
      context,
      (progress, size) => _CoinBurstPainter(
        progress: progress,
        anchor: anchor ?? size.center(Offset.zero),
        count: count,
        color: color,
      ),
      duration: const Duration(milliseconds: 900),
    );
    play(Sfx.coin);
    haptic(HapticLevel.light);
  }

  /// 连击浮标：在 [anchor] 处弹出 "COMBO x{n}"。
  static void combo(
    BuildContext context, {
    required int count,
    Offset? anchor,
  }) {
    _pushOverlay(
      context,
      (progress, size) => _ComboBadgePainter(
        progress: progress,
        anchor: anchor ?? size.center(Offset.zero),
        count: count,
      ),
      duration: const Duration(milliseconds: 800),
      overlayBuilder: (progress, size) {
        if (progress < 0.15) return const SizedBox.shrink();
        return Positioned(
          left: (anchor ?? size.center(Offset.zero)).dx - 60,
          top: (anchor ?? size.center(Offset.zero)).dy - 70,
          child: Opacity(
            opacity: ((progress - 0.15) / 0.2).clamp(0.0, 1.0) *
                (1 - ((progress - 0.7) / 0.3).clamp(0.0, 1.0)),
            child: Transform.scale(
              scale: Curves.easeOutBack.transform(
                ((progress - 0.15) / 0.25).clamp(0.0, 1.0),
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color.lerp(const Color(0xFFFF5F3C), Colors.deepOrange,
                            count / 10) ??
                        const Color(0xFFFF5F3C),
                    const Color(0xFFFFD54F),
                  ]),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withValues(alpha: .5),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Text(
                  'COMBO x$count',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
    play(Sfx.combo, volume: 0.3 + min(count, 8) * 0.05);
    haptic(count >= 5 ? HapticLevel.heavy : HapticLevel.medium);
  }

  /// 暴击闪屏：全屏红光边缘脉冲 + "CRIT!"。
  static void critFlash(BuildContext context, {String label = 'CRIT!'}) {
    _pushOverlay(
      context,
      (progress, size) => _CritPainter(progress: progress, label: label),
      duration: const Duration(milliseconds: 700),
    );
    play(Sfx.crit);
    haptic(HapticLevel.heavy);
  }

  static void _pushOverlay(
    BuildContext context,
    CustomPainter Function(double progress, Size size) painter, {
    required Duration duration,
    Widget Function(double progress, Size size)? overlayBuilder,
  }) {
    final controller = AnimationController(
      vsync: Navigator.of(context),
      duration: duration,
    );
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          if (controller.status == AnimationStatus.completed) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (entry.mounted) entry.remove();
              controller.dispose();
            });
          }
          final size = MediaQuery.sizeOf(context);
          return Stack(
            children: [
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: painter(controller.value, size),
                  ),
                ),
              ),
              if (overlayBuilder != null)
                IgnorePointer(child: overlayBuilder(controller.value, size)),
            ],
          );
        },
      ),
    );
    Overlay.of(context).insert(entry);
    controller.forward();
  }
}

enum HapticLevel { light, medium, heavy }

/// 金币迸发粒子。
class _CoinBurstPainter extends CustomPainter {
  final double progress;
  final Offset anchor;
  final int count;
  final Color color;

  _CoinBurstPainter({
    required this.progress,
    required this.anchor,
    required this.count,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;
    final rng = Random(11);
    for (var i = 0; i < count; i++) {
      final angle = rng.nextDouble() * 2 * pi;
      final speed = 60 + rng.nextDouble() * 90;
      final gravity = 160;
      final t = progress;
      final dx = cos(angle) * speed * t;
      final dy = sin(angle) * speed * t + gravity * t * t;
      final pos = anchor + Offset(dx, dy);
      final opacity = (1 - t).clamp(0.0, 1.0);
      final radius = 5 * (1 - t * 0.5);

      canvas.drawCircle(
        pos,
        radius,
        Paint()..color = color.withValues(alpha: opacity),
      );
      canvas.drawCircle(
        pos,
        radius * 0.55,
        Paint()
          ..color = Colors.white.withValues(alpha: opacity * 0.7),
      );
    }
  }

  @override
  bool shouldRepaint(_CoinBurstPainter old) => old.progress != progress;
}

/// 连击浮标底光。
class _ComboBadgePainter extends CustomPainter {
  final double progress;
  final Offset anchor;
  final int count;

  _ComboBadgePainter({
    required this.progress,
    required this.anchor,
    required this.count,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1 || count < 2) return;
    final opacity = (1 - progress).clamp(0.0, 1.0) * 0.6;
    canvas.drawCircle(
      anchor,
      26 + 30 * progress,
      Paint()
        ..color = Colors.orange.withValues(alpha: opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );
  }

  @override
  bool shouldRepaint(_ComboBadgePainter old) =>
      old.progress != progress || old.count != count;
}

/// 暴击边缘红光 + 大字。
class _CritPainter extends CustomPainter {
  final double progress;
  final String label;

  _CritPainter({required this.progress, required this.label});

  @override
  void paint(Canvas canvas, Size size) {
    final t = progress.clamp(0.0, 1.0);
    if (t <= 0 || t >= 1) return;

    // 边缘红光脉冲
    final glow = (1 - t) * 0.8;
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(
      rect,
      Paint()
        ..color = const Color(0xFFE02020).withValues(alpha: glow * 0.35)
        ..maskFilter = MaskFilter.blur(BlurStyle.outer, 40),
    );

    // 中央 CRIT 大字
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          fontSize: 52 + 10 * (1 - t),
          fontWeight: FontWeight.w900,
          color: const Color(0xFFE02020).withValues(alpha: (1 - t).clamp(0.0, 1.0)),
          shadows: const [Shadow(blurRadius: 18, color: Colors.white)],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      Offset(
        size.width / 2 - textPainter.width / 2,
        size.height * 0.32 - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(_CritPainter old) => old.progress != progress;
}
