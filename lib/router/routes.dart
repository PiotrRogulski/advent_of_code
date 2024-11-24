import 'package:advent_of_code/design_system/theme.dart';
import 'package:advent_of_code/features/day/day_page.dart';
import 'package:advent_of_code/features/home/home_page.dart';
import 'package:advent_of_code/features/settings/settings_page.dart';
import 'package:advent_of_code/features/years/year_page.dart';
import 'package:advent_of_code/features/years/years_page.dart';
import 'package:advent_of_code/router/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'branches/home.dart';
part 'branches/settings.dart';
part 'branches/years.dart';
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
  initialLocation: const YearsRoute().location,
);

@TypedStatefulShellRoute<MainRoute>(
  branches: [
    TypedStatefulShellBranch<HomeBranch>(
      routes: [TypedGoRoute<HomeRoute>(path: '/home')],
    ),
    TypedStatefulShellBranch<YearsBranch>(
      routes: [
        TypedGoRoute<YearsRoute>(
          path: '/years',
          routes: [
            TypedGoRoute<YearRoute>(
              path: ':year',
              routes: [TypedGoRoute<DayRoute>(path: ':day')],
            ),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch<SettingsBranch>(
      routes: [TypedGoRoute<SettingsRoute>(path: '/settings')],
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
    return FontOpticalSizeAdjuster(
      child: AocAppShell(routerState: state, navigationShell: navigationShell),
    );
  }
}
