import 'package:flutter/material.dart';

import '../juice/juice_fx.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/utils/localized_text.dart';
import '../../core/utils/money.dart';

enum ThemePref { system, light, dark }

/// 偏好持久化（语言/地区币种/主题模式）。
class AppPreferences {
  static const _kTheme = 'pref_theme_mode';
  static const _kLang = 'pref_language';
  static const _kRegion = 'pref_region';
  static const _kSfx = 'pref_sfx';

  final SharedPreferences _sp;

  AppPreferences(this._sp);

  ThemePref get theme =>
      ThemePref.values.asNameMap()[_sp.getString(_kTheme)] ?? ThemePref.system;

  Future<void> setTheme(ThemePref v) => _sp.setString(_kTheme, v.name);

  AppLanguage get language {
    final raw = _sp.getString(_kLang);
    if (raw == null) return _systemLang();
    return AppLanguage.values.asNameMap()[raw] ?? _systemLang();
  }

  AppLanguage _systemLang() {
    final l = WidgetsBinding.instance.platformDispatcher.locale;
    return AppLanguageX.fromLocale(l);
  }

  Future<void> setLanguage(AppLanguage v) => _sp.setString(_kLang, v.name);

  bool get sfxEnabled => _sp.getBool(_kSfx) ?? true;

  Future<void> setSfxEnabled(bool v) {
    JuiceFX.setSfxEnabled(v);
    return _sp.setBool(_kSfx, v);
  }

  FxCurrency get region {
    final raw = _sp.getString(_kRegion);
    if (raw == null) return FxCurrency.cny;
    return FxCurrency.values.asNameMap()[raw] ?? FxCurrency.cny;
  }

  Future<void> setRegion(FxCurrency v) => _sp.setString(_kRegion, v.name);
}

final sharedPrefsProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('override in main()');
});

final preferencesProvider =
    Provider((ref) => AppPreferences(ref.watch(sharedPrefsProvider)));

final themePrefProvider = StateProvider<ThemePref>(
  (ref) => ref.watch(preferencesProvider).theme,
);

/// null = 跟随系统语言。
final languageProvider = StateProvider<AppLanguage?>(
  (ref) => ref.watch(preferencesProvider).language,
);

final regionProvider = StateProvider<FxCurrency>(
  (ref) => ref.watch(preferencesProvider).region,
);

final sfxEnabledProvider = StateProvider<bool>(
  (ref) => ref.watch(preferencesProvider).sfxEnabled,
);

/// 持久化副作用监听：UI 只改 state，这里负责落盘。
final preferenceSyncProvider = Provider<void>((ref) {
  final prefs = ref.watch(preferencesProvider);
  ref.listen(themePrefProvider, (_, next) => prefs.setTheme(next));
  ref.listen(languageProvider, (_, next) {
    if (next != null) prefs.setLanguage(next);
  });
  ref.listen(regionProvider, (_, next) => prefs.setRegion(next));
  ref.listen(sfxEnabledProvider, (_, next) => prefs.setSfxEnabled(next));
});
