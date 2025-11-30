part of '../routes.dart';

class SettingsBranch extends StatefulShellBranchData {
  const SettingsBranch();

  static final $navigatorKey = navigatorKeys.branches.settings;
}

class SettingsRoute extends GoRouteData with $SettingsRoute {
  const SettingsRoute();

  static final $parentNavigatorKey = SettingsBranch.$navigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      const SettingsPage();
}
