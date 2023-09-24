part of '../routes.dart';

class YearsBranch extends StatefulShellBranchData {
  const YearsBranch();

  static final $navigatorKey = navigatorKeys.branches.years;
}

class YearsRoute extends GoRouteData {
  const YearsRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return const YearsPage();
  }
}

class YearRoute extends GoRouteData {
  const YearRoute({required this.year});

  final int year;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return YearPage(year: year);
  }
}
