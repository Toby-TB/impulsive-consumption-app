import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';
import 'juice_fx.dart';

/// 加购连击状态。
class ComboState {
  final int count;
  final Offset? lastAnchor;

  const ComboState({this.count = 0, this.lastAnchor});
}

/// 全局连击控制器：2.5s 内连续加购累积，中断归零。
/// combo≥2 时触发特效与金币奖励（10×combo）。
class ComboController extends Notifier<ComboState> {
  Timer? _resetTimer;
  BuildContext? _context;

  @override
  ComboState build() {
    ref.onDispose(() => _resetTimer?.cancel());
    return const ComboState();
  }

  /// 绑定用于特效的 context（首页/详情页 initState 调用一次）。
  void attachContext(BuildContext context) => _context = context;

  void registerAdd({Offset? anchor}) {
    _resetTimer?.cancel();
    final next = state.count + 1;
    state = ComboState(count: next, lastAnchor: anchor ?? state.lastAnchor);

    if (next >= 2) {
      final ctx = _context;
      if (ctx != null && ctx.mounted) {
        JuiceFX.combo(ctx, count: next, anchor: anchor);
      }
      // 连击金币奖励
      ref
          .read(gamificationServiceProvider)
          .awardComboCoins(next)
          .then((_) {}, onError: (_) {});
    }

    _resetTimer = Timer(const Duration(milliseconds: 2500), () {
      state = const ComboState();
    });
  }

  void reset() {
    _resetTimer?.cancel();
    state = const ComboState();
  }
}

final comboProvider =
    NotifierProvider<ComboController, ComboState>(ComboController.new);
