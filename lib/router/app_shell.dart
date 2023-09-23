import 'package:advent_of_code/common/extensions/brightness.dart';
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
    final brightness = Theme.of(context).brightness;

    final index = navigationShell.currentIndex;

    final destinations = [
      _Destination(
        icon: Icons.home,
        label: 'Home',
        index: 0,
        currentIndex: index,
      ),
      _Destination(
        icon: Icons.calendar_month,
        label: 'Years',
        index: 1,
        currentIndex: index,
      ),
      _Destination(
        icon: Icons.settings,
        label: 'Settings',
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
    required IconData icon,
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

  final IconData icon;
  final int index;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final selected = currentIndex == index;

    return TweenAnimationBuilder(
      tween: ColorTween(
        begin: colors.onSurface,
        end: selected ? colors.primary : colors.onSurface,
      ),
      duration: const Duration(milliseconds: 200),
      builder: (context, color, _) {
        // TODO: animate icon fill
        return Icon(
          icon,
          color: color,
        );
      },
    );
  }
}
