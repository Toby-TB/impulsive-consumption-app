import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/juice/juice_fx.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/widgets/common.dart';
import '../../../data/services/gamification_service.dart';

class GachaScreen extends ConsumerStatefulWidget {
  const GachaScreen({super.key});

  @override
  ConsumerState<GachaScreen> createState() => _GachaScreenState();
}

class _GachaScreenState extends ConsumerState<GachaScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shake = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );
  bool _opening = false;

  @override
  void dispose() {
    _shake.dispose();
    super.dispose();
  }

  Future<void> _open() async {
    if (_opening) return;
    setState(() => _opening = true);
    JuiceFX.play(Sfx.gacha);
    JuiceFX.haptic(HapticLevel.medium);
    _shake.repeat(reverse: true);

    try {
      final prize =
          await ref.read(gamificationServiceProvider).openGacha();
      if (!mounted) return;
      _shake.stop();
      _shake.value = 0;
      JuiceFX.haptic(HapticLevel.heavy);
      if (prize.rarity == GachaRarity.ssr) {
        JuiceFX.critFlash(context, label: 'SSR!');
      } else {
        JuiceFX.coinBurst(context, count: 22);
      }
      _showPrize(prize);
    } on InsufficientCoinsException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(context.l10n.notEnoughCoins),
            duration: const Duration(milliseconds: 900)),
      );
      JuiceFX.haptic(HapticLevel.heavy);
    } finally {
      if (mounted) setState(() => _opening = false);
    }
  }

  void _showPrize(GachaPrize prize) {
    final l = context.l10n;
    final label = switch (prize.key) {
      'prizeCoins150' => l.prizeCoins150,
      'prizeCoins400' => l.prizeCoins400,
      'prizeCoins2000' => l.prizeCoins2000,
      'prizeCredit1' => l.prizeCredit1,
      'prizeCredit20' => l.prizeCredit20,
      'prizeCredit50' => l.prizeCredit50,
      _ => l.prizeCoupon,
    };
    final rarityLabel = switch (prize.rarity) {
      GachaRarity.n => l.rarityN,
      GachaRarity.r => l.rarityR,
      GachaRarity.sr => l.raritySR,
      GachaRarity.ssr => l.raritySSR,
    };
    final color = switch (prize.rarity) {
      GachaRarity.n => const Color(0xFF9E9E9E),
      GachaRarity.r => const Color(0xFF2196F3),
      GachaRarity.sr => const Color(0xFF9C27B0),
      GachaRarity.ssr => const Color(0xFFFFB300),
    };

    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Theme.of(ctx).cardColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: color, width: 2.5),
            boxShadow: [
              BoxShadow(color: color.withValues(alpha: .55), blurRadius: 34),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(rarityLabel,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: color)),
              ),
              const SizedBox(height: 16),
              Icon(
                switch (prize.type) {
                  GachaType.coins => Icons.monetization_on,
                  GachaType.credit => Icons.redeem,
                  GachaType.coupon => Icons.local_offer,
                },
                size: 60,
                color: color,
              ),
              const SizedBox(height: 12),
              Text(label,
                  style: const TextStyle(
                      fontSize: 19, fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final coins = ref.watch(_coinsProvider).value ?? 0;
    final pity = ref.watch(_pityProvider).value ?? 0;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l.gachaTitle)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 金币余额
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.monetization_on,
                    color: Color(0xFFFFC93C), size: 20),
                const SizedBox(width: 6),
                Text('${l.coinsLabel}: $coins',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l.gachaPity(10 - pity),
              style: TextStyle(fontSize: 12, color: theme.hintColor),
            ),
            const SizedBox(height: 30),

            // 盒子
            GestureDetector(
              onTap: _open,
              child: AnimatedBuilder(
                animation: _shake,
                builder: (context, _) {
                  final angle = _opening
                      ? sin(_shake.value * pi * 6) * 0.12
                      : 0.0;
                  final scale =
                      1 + (_opening ? sin(_shake.value * pi) * 0.06 : 0.0);
                  return Transform.rotate(
                    angle: angle,
                    child: Transform.scale(
                      scale: scale,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF5F3C), Color(0xFFFF9A44)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF5F3C)
                                  .withValues(alpha: .45),
                              blurRadius: 30,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text('🎁',
                              style: TextStyle(fontSize: 72)),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 34),

            FilledButton(
              onPressed: _opening ? null : _open,
              style: FilledButton.styleFrom(minimumSize: const Size(200, 52)),
              child: Text(
                coins < GamificationService.kGachaCost
                    ? l.gachaNeedCoins(GamificationService.kGachaCost - coins)
                    : l.gachaOpen(GamificationService.kGachaCost),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              '${l.coinsLabel} 1000 → ¥10 · ${l.exchangeCoins}',
              style: TextStyle(fontSize: 11, color: theme.hintColor),
            ),
          ],
        ),
      ),
    );
  }
}

final _coinsProvider = StreamProvider(
  (ref) => ref.watch(gamificationServiceProvider).watchCoins(),
);

final _pityProvider = StreamProvider(
  (ref) => ref.watch(gamificationServiceProvider).watchState().map(
        (s) => s.gachaPity,
      ),
);
