import 'package:advent_of_code/common/widgets/breakpoint_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';

class SliverAdaptiveList<T> extends StatelessWidget {
  const SliverAdaptiveList({
    super.key,
    required this.items,
    required this.listItemBuilder,
    required this.gridItemBuilder,
  });

  final Iterable<T> items;
  final Widget Function(BuildContext, T) listItemBuilder;
  final Widget Function(BuildContext, T) gridItemBuilder;

  @override
  Widget build(BuildContext context) {
    return BreakpointSelector(
      builders: {
        Breakpoints.small: (_) => _SliverList(
              items: items,
              itemBuilder: listItemBuilder,
            ),
        null: (_) => _SliverGrid(
              items: items,
              itemBuilder: gridItemBuilder,
            ),
      },
    );
  }
}

class _SliverList<T> extends StatelessWidget {
  const _SliverList({
    required this.items,
    required this.itemBuilder,
  });

  final Iterable<T> items;
  final Widget Function(BuildContext, T) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items.elementAt(index);
        return itemBuilder(context, item);
      },
    );
  }
}

class _SliverGrid<T> extends StatelessWidget {
  const _SliverGrid({
    required this.items,
    required this.itemBuilder,
  });

  final Iterable<T> items;
  final Widget Function(BuildContext, T) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150,
      ),
      delegate: SliverChildBuilderDelegate(
        childCount: items.length,
        (context, index) {
          final item = items.elementAt(index);
          return itemBuilder(context, item);
        },
      ),
    );
  }
}
