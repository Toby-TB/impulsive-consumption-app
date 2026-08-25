import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/juice/juice_fx.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/common.dart';

/// 支付庆祝数据。
class PaymentCelebration {
  final int payableCents;
  final int xpGained;
  final int impulseGained;
  final int oldLevel;
  final int newLevel;
  final int levelUpRewardCents;
  final int coinsGained;
  final List<String> achievementKeys;

  bool get leveledUp => newLevel > oldLevel;

  const PaymentCelebration({
    required this.payableCents,
    required this.xpGained,
    required this.impulseGained,
    required this.oldLevel,
    required this.newLevel,
    required this.levelUpRewardCents,
    required this.achievementKeys,
    this.coinsGained = 0,
  });
}

/// 全屏支付成功动效：
/// 彩屑雨 + 冲击波圆环 + 对勾描边 + 金额滚动 + 经验/冲动值 + 升级徽章 + 成就列表。
/// 点击任意处跳到结尾；播完回调 [onFinished]。
void showPaymentSuccess(
  BuildContext context, {
  required PaymentCelebration celebration,
  required FxCurrency region,
  required String locale,
  required String Function(String key) localizeAchievement,
  required String continueLabel,
  required VoidCallback onFinished,
}) {
  final controller = AnimationController(
    vsync: Navigator.of(context),
    duration: const Duration(milliseconds: 3600),
  );
  late final OverlayEntry entry;
  var finished = false;

  void finish() {
    if (finished) return;
    finished = true;
    if (entry.mounted) entry.remove();
    controller.dispose();
    onFinished();
  }

  entry = OverlayEntry(
    builder: (_) => _SuccessOverlay(
      controller: controller,
      celebration: celebration,
      region: region,
      locale: locale,
      localizeAchievement: localizeAchievement,
      continueLabel: continueLabel,
      onDismissed: finish,
    ),
  );

  Overlay.of(context, rootOverlay: true).insert(entry);
  controller.forward();
  // 金币爆发（圆环出现后）
  Future.delayed(const Duration(milliseconds: 500), () {
    if (context.mounted) JuiceFX.coinBurst(context, count: 18);
  });
  // 双保险：无论动画状态如何，4.5s 后强制退场，绝不卡死用户
  Future.delayed(const Duration(milliseconds: 4500), finish);
}

class _SuccessOverlay extends StatelessWidget {
  final AnimationController controller;
  final PaymentCelebration celebration;
  final FxCurrency region;
  final String locale;
  final String Function(String key) localizeAchievement;
  final String continueLabel;
  final VoidCallback onDismissed;

  const _SuccessOverlay({
    required this.controller,
    required this.celebration,
    required this.region,
    required this.locale,
    required this.localizeAchievement,
    required this.continueLabel,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: .78),
      child: GestureDetector(
        onTap: () {
          if (controller.status != AnimationStatus.completed) {
            controller.value = 1.0;
          }
        },
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            // 彩屑层
            Positioned.fill(
              child: AnimatedBuilder(
                animation: controller,
                builder: (_, _) => CustomPaint(
                  painter: _ConfettiPainter(progress: controller.value),
                ),
              ),
            ),
            // 中央结算
            Center(
              child: AnimatedBuilder(
                animation: controller,
                builder: (context, _) {
                  return _CelebrationCard(
                    progress: controller.value,
                    celebration: celebration,
                    region: region,
                    locale: locale,
                    localizeAchievement: localizeAchievement,
                    continueLabel: continueLabel,
                    onContinue: onDismissed,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CelebrationCard extends StatelessWidget {
  final double progress;
  final PaymentCelebration celebration;
  final FxCurrency region;
  final String locale;
  final String Function(String key) localizeAchievement;
  final String continueLabel;
  final VoidCallback onContinue;

  const _CelebrationCard({
    required this.progress,
    required this.celebration,
    required this.region,
    required this.locale,
    required this.localizeAchievement,
    required this.continueLabel,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    // 阶段进度
    final ringT = ((progress - 0.0) / 0.35).clamp(0.0, 1.0);
    final amountT = ((progress - 0.30) / 0.30).clamp(0.0, 1.0);
    final statsT = ((progress - 0.55) / 0.25).clamp(0.0, 1.0);
    final badgeT = ((progress - 0.70) / 0.25).clamp(0.0, 1.0);

    // 金额滚动
    final shownCents =
        (celebration.payableCents * Curves.easeOutCubic.transform(amountT)).round();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 圆环+对勾
        SizedBox(
          width: 150,
          height: 150,
          child: CustomPaint(
            painter: _RingCheckPainter(progress: ringT),
          ),
        ),
        const SizedBox(height: 18),

        // 金额
        if (amountT > 0)
          Opacity(
            opacity: amountT,
            child: Transform.scale(
              scale: 0.8 + 0.2 * Curves.easeOutBack.transform(amountT),
              child: MoneyText(
                shownCents,
                style: const TextStyle(
                    fontSize: 40, color: Colors.white, fontWeight: FontWeight.w800),
                color: Colors.white,
              ),
            ),
          ),
        const SizedBox(height: 14),

        // XP / 冲动值 chips
        if (statsT > 0)
          Opacity(
            opacity: statsT,
            child: Transform.translate(
              offset: Offset(0, 16 * (1 - statsT)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _StatChip(
                    text: '+${celebration.xpGained} EXP',
                    color: const Color(0xFF64B5F6),
                  ),
                  const SizedBox(width: 10),
                  if (celebration.coinsGained > 0)
                    _StatChip(
                      text: '+${celebration.coinsGained} 🪙',
                      color: const Color(0xFFFFC93C),
                    ),
                  if (celebration.impulseGained > 0) ...[
                    const SizedBox(width: 10),
                    _StatChip(
                      text: '+${celebration.impulseGained} ⚡',
                      color: const Color(0xFFFF9A44),
                    ),
                  ],
                ],
              ),
            ),
          ),

        // 升级徽章
        if (celebration.leveledUp && badgeT > 0)
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: Transform.scale(
              scale: Curves.easeOutBack.transform(badgeT),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xFFFFD54F), Color(0xFFFF9A44)]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '⬆ Lv.${celebration.oldLevel} → Lv.${celebration.newLevel}',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF4A2800)),
                ),
              ),
            ),
          ),

        // 成就
        for (final key in celebration.achievementKeys.take(3))
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Opacity(
              opacity: badgeT.clamp(0.0, 1.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.emoji_events,
                      size: 16, color: Color(0xFFFFD54F)),
                  const SizedBox(width: 6),
                  Text(
                    localizeAchievement(key),
                    style: const TextStyle(
                        fontSize: 13, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),

        const SizedBox(height: 26),
        // 继续按钮
        if (progress > 0.85)
          Opacity(
            opacity: ((progress - 0.85) / 0.15).clamp(0.0, 1.0),
            child: FilledButton(
              onPressed: onContinue,
              style: FilledButton.styleFrom(
                minimumSize: const Size(140, 44),
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFFE02020),
              ),
              child: Text(continueLabel),
            ),
          ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String text;
  final Color color;

  const _StatChip({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .18),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: .6)),
      ),
      child: Text(text,
          style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w700, color: color)),
    );
  }
}

/// 圆环冲击波 + 对勾描边。
class _RingCheckPainter extends CustomPainter {
  final double progress;

  _RingCheckPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final t = progress.clamp(0.0, 1.0);

    // 两道冲击波
    for (final wave in [0.0, 0.18]) {
      final wt = ((t - wave) / 0.5).clamp(0.0, 1.0);
      if (wt <= 0 || wt >= 1) continue;
      canvas.drawCircle(
        center,
        30 + 60 * wt,
        Paint()
          ..color = const Color(0xFF2ECC71).withValues(alpha: (1 - wt) * .5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3 * (1 - wt) + 1,
      );
    }

    // 主圆
    final circleT = Curves.easeOutBack.transform(t);
    canvas.drawCircle(center, 52 * circleT, Paint()..color = const Color(0xFF2ECC71));

    // 对勾
    if (t > 0.3) {
      final checkT = ((t - 0.3) / 0.5).clamp(0.0, 1.0);
      final path = Path()
        ..moveTo(center.dx - 22, center.dy + 2)
        ..lineTo(center.dx - 5, center.dy + 19)
        ..lineTo(center.dx + 24, center.dy - 17);
      final metric = path.computeMetrics().first;
      canvas.drawPath(
        metric.extractPath(0, metric.length * checkT),
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 7
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }
  }

  @override
  bool shouldRepaint(_RingCheckPainter old) => old.progress != progress;
}

/// 彩屑雨。
class _ConfettiPainter extends CustomPainter {
  final double progress;

  _ConfettiPainter({required this.progress});

  static final _pieces = List.generate(80, (i) {
    final rng = Random(i);
    return (
      x: rng.nextDouble(),
      fallSpeed: 0.8 + rng.nextDouble() * 1.4,
      stagger: rng.nextDouble() * 0.8,
      size: 4 + rng.nextDouble() * 5,
      spin: rng.nextDouble() * pi * 2,
      colorIndex: rng.nextInt(5),
    );
  });

  static const _palette = [
    Color(0xFFFF5F3C), Color(0xFFFFD54F), Color(0xFF64B5F6),
    Color(0xFF81C784), Color(0xFFB388FF),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;
    final fade = (1 - progress).clamp(0.0, 1.0) * 0.9 + 0.1;

    for (final p in _pieces) {
      final t = progress * p.fallSpeed + p.stagger;
      final y = ((t % 1.3) - 0.1) * size.height;
      final x = p.x * size.width + sin(t * 6 + p.spin) * 18;
      if (y < -10 || y > size.height + 10) continue;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(p.spin + t * 5);
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: p.size,
          height: p.size * 0.55,
        ),
        Paint()..color = _palette[p.colorIndex].withValues(alpha: fade),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.progress != progress;
}
