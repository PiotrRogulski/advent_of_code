part of '../routes.dart';

class const HomeBranch() extends StatefulShellBranchData {
  static final $navigatorKey = navigatorKeys.branches.home;
}

class const HomeRoute() extends GoRouteData with $HomeRoute {
  static final $parentNavigatorKey = HomeBranch.$navigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      const HomePage();
}
