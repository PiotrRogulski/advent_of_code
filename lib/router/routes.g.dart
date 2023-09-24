// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $mainRoute,
    ];

RouteBase get $mainRoute => StatefulShellRouteData.$route(
      factory: $MainRouteExtension._fromState,
      branches: [
        StatefulShellBranchData.$branch(
          navigatorKey: HomeBranch.$navigatorKey,
          routes: [
            GoRouteData.$route(
              path: '/home',
              factory: $HomeRouteExtension._fromState,
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          navigatorKey: YearsBranch.$navigatorKey,
          routes: [
            GoRouteData.$route(
              path: '/years',
              factory: $YearsRouteExtension._fromState,
              routes: [
                GoRouteData.$route(
                  path: ':year',
                  factory: $YearRouteExtension._fromState,
                  routes: [
                    GoRouteData.$route(
                      path: ':day',
                      factory: $DayRouteExtension._fromState,
                      routes: [
                        GoRouteData.$route(
                          path: ':part',
                          factory: $PartRouteExtension._fromState,
                        ),
                      ],
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
              factory: $SettingsRouteExtension._fromState,
            ),
          ],
        ),
      ],
    );

extension $MainRouteExtension on MainRoute {
  static MainRoute _fromState(GoRouterState state) => const MainRoute();
}

extension $HomeRouteExtension on HomeRoute {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  String get location => GoRouteData.$location(
        '/home',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $YearsRouteExtension on YearsRoute {
  static YearsRoute _fromState(GoRouterState state) => const YearsRoute();

  String get location => GoRouteData.$location(
        '/years',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $YearRouteExtension on YearRoute {
  static YearRoute _fromState(GoRouterState state) => YearRoute(
        year: int.parse(state.pathParameters['year']!),
      );

  String get location => GoRouteData.$location(
        '/years/${Uri.encodeComponent(year.toString())}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $DayRouteExtension on DayRoute {
  static DayRoute _fromState(GoRouterState state) => DayRoute(
        year: int.parse(state.pathParameters['year']!),
        day: int.parse(state.pathParameters['day']!),
      );

  String get location => GoRouteData.$location(
        '/years/${Uri.encodeComponent(year.toString())}/${Uri.encodeComponent(day.toString())}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $PartRouteExtension on PartRoute {
  static PartRoute _fromState(GoRouterState state) => PartRoute(
        year: int.parse(state.pathParameters['year']!),
        day: int.parse(state.pathParameters['day']!),
        part: int.parse(state.pathParameters['part']!),
      );

  String get location => GoRouteData.$location(
        '/years/${Uri.encodeComponent(year.toString())}/${Uri.encodeComponent(day.toString())}/${Uri.encodeComponent(part.toString())}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $SettingsRouteExtension on SettingsRoute {
  static SettingsRoute _fromState(GoRouterState state) => const SettingsRoute();

  String get location => GoRouteData.$location(
        '/settings',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
