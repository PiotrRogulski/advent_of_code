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

class DayRoute extends GoRouteData {
  const DayRoute({required this.year, required this.day});

  final int year;
  final int day;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return DayPage(year: year, day: day);
  }
}

class PartRoute extends GoRouteData {
  const PartRoute({required this.year, required this.day, required this.part});

  final int year;
  final int day;
  final int part;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return PartPage(year: year, day: day, part: part);
  }
}
