import 'package:advent_of_code/common/hooks/use_value_stream.dart';
import 'package:advent_of_code/design_system/theme.dart';
import 'package:advent_of_code/features/christmas/christmas_overlay.dart';
import 'package:advent_of_code/features/settings/settings_store.dart';
import 'package:advent_of_code/l10n/app_localizations.dart';
import 'package:advent_of_code/router/routes.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

class const AocApp({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        return HookBuilder(
          builder: (context) {
            final settings = context.read<SettingsStore>();
            final themeMode = useValueStream(settings.themeMode);
            final locale = useValueStream(settings.locale);
            final useSystemTheme = useValueStream(settings.useSystemTheme);

            return MaterialApp.router(
              themeMode: themeMode,
              theme: AocTheme.light(useSystemTheme ? lightDynamic : null),
              darkTheme: AocTheme.dark(useSystemTheme ? darkDynamic : null),
              localizationsDelegates: const [
                ...AppLocalizations.localizationsDelegates,
                ...GlobalMaterialLocalizations.delegates,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              locale: locale.locale,
              routerConfig: router,
              debugShowCheckedModeBanner: false,
              builder: (context, child) =>
                  AocTextTheme(child: ChristmasOverlay(child: child!)),
            );
          },
        );
      },
    );
  }
}
