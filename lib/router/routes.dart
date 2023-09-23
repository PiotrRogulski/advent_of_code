import 'package:advent_of_code/features/home/home_page.dart';
import 'package:advent_of_code/features/settings/settings_page.dart';
import 'package:advent_of_code/features/years/years_page.dart';
import 'package:advent_of_code/router/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'routes.g.dart';

final navigatorKeys = (
  root: GlobalKey<NavigatorState>(),
  branches: (
    home: GlobalKey<NavigatorState>(),
    years: GlobalKey<NavigatorState>(),
    settings: GlobalKey<NavigatorState>(),
  ),
);

final router = GoRouter(
  navigatorKey: navigatorKeys.root,
  routes: $appRoutes,
  initialLocation: const HomeRoute().location,
);

@TypedStatefulShellRoute<MainRoute>(
  branches: [
    TypedStatefulShellBranch<HomeBranch>(
      routes: [
        TypedGoRoute<HomeRoute>(path: '/home'),
      ],
    ),
    TypedStatefulShellBranch<YearsBranch>(
      routes: [
        TypedGoRoute<YearsRoute>(path: '/years'),
      ],
    ),
    TypedStatefulShellBranch<SettingsBranch>(
      routes: [
        TypedGoRoute<SettingsRoute>(path: '/settings'),
      ],
    ),
  ],
)
class MainRoute extends StatefulShellRouteData {
  const MainRoute();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return AocAppShell(
      routerState: state,
      navigationShell: navigationShell,
    );
  }
}

class HomeBranch extends StatefulShellBranchData {
  const HomeBranch();

  static final $navigatorKey = navigatorKeys.branches.home;
}

class YearsBranch extends StatefulShellBranchData {
  const YearsBranch();

  static final $navigatorKey = navigatorKeys.branches.years;
}

class SettingsBranch extends StatefulShellBranchData {
  const SettingsBranch();

  static final $navigatorKey = navigatorKeys.branches.settings;
}

class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return const HomePage();
  }
}

class YearsRoute extends GoRouteData {
  const YearsRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return const YearsPage();
  }
}

class SettingsRoute extends GoRouteData {
  const SettingsRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return const SettingsPage();
  }
}
