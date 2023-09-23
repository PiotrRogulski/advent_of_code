part of '../routes.dart';

class HomeBranch extends StatefulShellBranchData {
  const HomeBranch();

  static final $navigatorKey = navigatorKeys.branches.home;
}

class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return const HomePage();
  }
}
