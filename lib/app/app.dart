import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/localization/app_localizations_x.dart';
import '../core/localization/locale_provider.dart';
import '../l10n/app_localizations.dart';
import 'router.dart';
import 'theme.dart';

class CateringApp extends ConsumerWidget {
  const CateringApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeState = ref.watch(appLocaleProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => context.l10n.appTitle,
      theme: AppTheme.lightTheme,
      scrollBehavior: const _IosLikeScrollBehavior(),
      initialRoute: AppRouter.shell,
      onGenerateRoute: AppRouter.onGenerateRoute,
      locale: localeState.locale,
      supportedLocales: supportedAppLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      localeListResolutionCallback: (deviceLocales, supportedLocales) {
        if (localeState.locale != null) {
          return localeState.locale;
        }

        for (final deviceLocale in deviceLocales ?? const <Locale>[]) {
          for (final supportedLocale in supportedAppLocales) {
            if (supportedLocale.languageCode == deviceLocale.languageCode) {
              return supportedLocale;
            }
          }
        }
        return fallbackAppLocale;
      },
    );
  }
}

class _IosLikeScrollBehavior extends MaterialScrollBehavior {
  const _IosLikeScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
  }
}
