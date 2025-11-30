part of '../routes.dart';

class YearsBranch extends StatefulShellBranchData {
  const YearsBranch();

  static final $navigatorKey = navigatorKeys.branches.years;
}

class YearsRoute extends GoRouteData with $YearsRoute {
  const YearsRoute();

  static final $parentNavigatorKey = YearsBranch.$navigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      const YearsPage();
}

class YearRoute extends GoRouteData with $YearRoute {
  const YearRoute({required this.year});

  final int year;

  static final $parentNavigatorKey = YearsBranch.$navigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      YearPage(year: year);
}

class DayRoute extends GoRouteData with $DayRoute {
  const DayRoute({required this.year, required this.day});

  final int year;
  final int day;

  static final $parentNavigatorKey = YearsBranch.$navigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      DayPage(year: year, day: day);
}
