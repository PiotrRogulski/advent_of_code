part of '../routes.dart';

class SettingsBranch extends StatefulShellBranchData {
  const SettingsBranch();

  static final $navigatorKey = navigatorKeys.branches.settings;
}

class SettingsRoute extends GoRouteData {
  const SettingsRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return const SettingsPage();
  }
}
