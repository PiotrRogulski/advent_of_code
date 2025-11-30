// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$mainRoute];

RouteBase get $mainRoute => StatefulShellRouteData.$route(
  factory: $MainRouteExtension._fromState,
  branches: [
    StatefulShellBranchData.$branch(
      navigatorKey: HomeBranch.$navigatorKey,
      routes: [
        GoRouteData.$route(
          path: '/home',
          parentNavigatorKey: HomeRoute.$parentNavigatorKey,
          factory: $HomeRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      navigatorKey: YearsBranch.$navigatorKey,
      routes: [
        GoRouteData.$route(
          path: '/years',
          parentNavigatorKey: YearsRoute.$parentNavigatorKey,
          factory: $YearsRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: ':year',
              parentNavigatorKey: YearRoute.$parentNavigatorKey,
              factory: $YearRoute._fromState,
              routes: [
                GoRouteData.$route(
                  path: ':day',
                  parentNavigatorKey: DayRoute.$parentNavigatorKey,
                  factory: $DayRoute._fromState,
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      navigatorKey: SettingsBranch.$navigatorKey,
      routes: [
        GoRouteData.$route(
          path: '/settings',
          parentNavigatorKey: SettingsRoute.$parentNavigatorKey,
          factory: $SettingsRoute._fromState,
        ),
      ],
    ),
  ],
);

extension $MainRouteExtension on MainRoute {
  static MainRoute _fromState(GoRouterState state) => const MainRoute();
}

mixin $HomeRoute on GoRouteData {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  @override
  String get location => GoRouteData.$location('/home');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $YearsRoute on GoRouteData {
  static YearsRoute _fromState(GoRouterState state) => const YearsRoute();

  @override
  String get location => GoRouteData.$location('/years');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $YearRoute on GoRouteData {
  static YearRoute _fromState(GoRouterState state) =>
      YearRoute(year: int.parse(state.pathParameters['year']!));

  YearRoute get _self => this as YearRoute;

  @override
  String get location => GoRouteData.$location(
    '/years/${Uri.encodeComponent(_self.year.toString())}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $DayRoute on GoRouteData {
  static DayRoute _fromState(GoRouterState state) => DayRoute(
    year: int.parse(state.pathParameters['year']!),
    day: int.parse(state.pathParameters['day']!),
  );

  DayRoute get _self => this as DayRoute;

  @override
  String get location => GoRouteData.$location(
    '/years/${Uri.encodeComponent(_self.year.toString())}/${Uri.encodeComponent(_self.day.toString())}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SettingsRoute on GoRouteData {
  static SettingsRoute _fromState(GoRouterState state) => const SettingsRoute();

  @override
  String get location => GoRouteData.$location('/settings');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
