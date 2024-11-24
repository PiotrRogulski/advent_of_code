import 'package:advent_of_code/design_system/theme.dart';
import 'package:advent_of_code/features/settings/settings_store.dart';
import 'package:advent_of_code/global_providers.dart';
import 'package:advent_of_code/l10n/app_localizations.dart';
import 'package:advent_of_code/router/routes.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class AocApp extends StatelessWidget {
  const AocApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const AocProviders(child: _App());
  }
}

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        return Observer(
          builder: (context) {
            final SettingsStore(:themeMode, :useSystemTheme, :locale) =
                context.read();

            return MaterialApp.router(
              themeMode: themeMode,
              theme: AocTheme.light(useSystemTheme ? lightDynamic : null),
              darkTheme: AocTheme.dark(useSystemTheme ? darkDynamic : null),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: locale,
              routerConfig: router,
            );
          },
        );
      },
    );
  }
}
