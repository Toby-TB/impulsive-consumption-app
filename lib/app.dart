import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/providers/preferences_provider.dart';
import 'core/utils/localized_text.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';

class ImpulsiveApp extends ConsumerWidget {
  const ImpulsiveApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 激活偏好落盘监听
    ref.watch(preferenceSyncProvider);

    final themePref = ref.watch(themePrefProvider);
    final lang = ref.watch(languageProvider);

    return MaterialApp.router(
      title: 'Impulsive Consumption',
      debugShowCheckedModeBanner: false,
      routerConfig: ref.watch(routerProvider),

      // 主题
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: switch (themePref) {
        ThemePref.system => ThemeMode.system,
        ThemePref.light => ThemeMode.light,
        ThemePref.dark => ThemeMode.dark,
      },

      // 三语本地化
      locale: lang?.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
