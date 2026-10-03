part of '../routes.dart';

class const YearsBranch() extends StatefulShellBranchData {
  static final $navigatorKey = navigatorKeys.branches.years;
}

class const YearsRoute() extends GoRouteData with $YearsRoute {
  static final $parentNavigatorKey = YearsBranch.$navigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      const YearsPage();
}

class const YearRoute({required final int year})
    extends GoRouteData
    with $YearRoute {
  static final $parentNavigatorKey = YearsBranch.$navigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      YearPage(year: year);
}

class const DayRoute({required final int year, required final int day})
    extends GoRouteData
    with $DayRoute {
  static final $parentNavigatorKey = YearsBranch.$navigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      DayPage(year: year, day: day);
}
