import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/design_system/dynamic_weight.dart';
import 'package:advent_of_code/design_system/icons.dart';
import 'package:advent_of_code/design_system/widgets/icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:go_router/go_router.dart';

class AocAppShell extends StatelessWidget {
  const AocAppShell({
    super.key,
    required this.routerState,
    required this.navigationShell,
  });

  final GoRouterState routerState;
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final brightness = Theme.of(context).brightness;

    final index = navigationShell.currentIndex;

    final destinations = [
      _Destination(
        icon: AocIconData.home,
        label: s.home_title,
        index: 0,
        currentIndex: index,
      ),
      _Destination(
        icon: AocIconData.calendarMonth,
        label: s.years_title,
        index: 1,
        currentIndex: index,
      ),
      _Destination(
        icon: AocIconData.settings,
        label: s.settings_title,
        index: 2,
        currentIndex: index,
      ),
    ];

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarContrastEnforced: false,
        statusBarColor: Colors.transparent,
        systemStatusBarContrastEnforced: false,
        statusBarBrightness: brightness,
        statusBarIconBrightness: brightness.opposite,
        systemNavigationBarIconBrightness: brightness.opposite,
      ),
      child: AdaptiveScaffold(
        useDrawer: false,
        internalAnimations: false,
        destinations: destinations,
        onSelectedIndexChange: navigationShell.goBranch,
        selectedIndex: navigationShell.currentIndex,
        body: (context) => navigationShell,
      ),
    );
  }
}

class _Destination extends NavigationDestination {
  _Destination({
    required AocIconData icon,
    required super.label,
    required int index,
    required int currentIndex,
  }) : super(
         icon: _DestinationIcon(
           icon: icon,
           index: index,
           currentIndex: currentIndex,
         ),
       );
}

class _DestinationIcon extends StatelessWidget {
  const _DestinationIcon({
    required this.icon,
    required this.index,
    required this.currentIndex,
  });

  final AocIconData icon;
  final int index;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final selected = currentIndex == index;

    return AocIcon(
      icon,
      size: 24,
      color: selected ? colors.primary : colors.onSurface,
      fill: selected ? 1 : 0,
      weight: selected ? AocDynamicWeight.regular : AocDynamicWeight.light,
    );
  }
}
