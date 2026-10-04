import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/design_system/icons.dart';
import 'package:advent_of_code/design_system/widgets/icon.dart';
import 'package:custom_adaptive_scaffold/custom_adaptive_scaffold.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart' hide NavigationDestination;

class const AocAppShell({
  super.key,
  required final GoRouterState routerState,
  required final StatefulNavigationShell navigationShell,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final brightness = Theme.of(context).brightness;

    final index = navigationShell.currentIndex;

    final destinations = [
      _destination(
        icon: .home,
        label: s.home_title,
        index: 0,
        currentIndex: index,
      ),
      _destination(
        icon: .calendarMonth,
        label: s.years_title,
        index: 1,
        currentIndex: index,
      ),
      _destination(
        icon: .settings,
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

NavigationDestination _destination({
  required AocIconData icon,
  required String label,
  required int index,
  required int currentIndex,
}) => .new(
  icon: _DestinationIcon(icon: icon, index: index, currentIndex: currentIndex),
  label: label,
);

class const _DestinationIcon({
  required final AocIconData icon,
  required final int index,
  required final int currentIndex,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final selected = currentIndex == index;

    return AocIcon(
      icon,
      size: .large,
      color: selected ? colors.primary : colors.onSurface,
      fill: selected ? 1 : 0,
      weight: selected ? .regular : .light,
    );
  }
}
