part of '../routes.dart';

class const SettingsBranch() extends StatefulShellBranchData {
  static final $navigatorKey = navigatorKeys.branches.settings;
}

class const SettingsRoute() extends GoRouteData with $SettingsRoute {
  static final $parentNavigatorKey = SettingsBranch.$navigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      const SettingsPage();
}
