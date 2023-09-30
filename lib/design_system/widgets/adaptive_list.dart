import 'package:advent_of_code/common/widgets/breakpoint_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';

class SliverAdaptiveList<T> extends StatelessWidget {
  const SliverAdaptiveList({
    super.key,
    required this.items,
    required this.listItemBuilder,
    required this.gridItemBuilder,
    this.padding = const EdgeInsets.all(16),
  });

  final Iterable<T> items;
  final Widget Function(BuildContext, T) listItemBuilder;
  final Widget Function(BuildContext, T) gridItemBuilder;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return BreakpointSelector(
      builders: {
        Breakpoints.small: (_) => _SliverList(
              items: items,
              itemBuilder: listItemBuilder,
              padding: padding,
            ),
        null: (_) => _SliverGrid(
              items: items,
              itemBuilder: gridItemBuilder,
              padding: padding,
            ),
      },
    );
  }
}

class _SliverList<T> extends StatelessWidget {
  const _SliverList({
    required this.items,
    required this.itemBuilder,
    required this.padding,
  });

  final Iterable<T> items;
  final Widget Function(BuildContext, T) itemBuilder;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: padding,
      sliver: SliverList.separated(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items.elementAt(index);
          return itemBuilder(context, item);
        },
        separatorBuilder: (context, index) =>
            SizedBox(height: padding.vertical / 2),
      ),
    );
  }
}

class _SliverGrid<T> extends StatelessWidget {
  const _SliverGrid({
    required this.items,
    required this.itemBuilder,
    required this.padding,
  });

  final Iterable<T> items;
  final Widget Function(BuildContext, T) itemBuilder;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: padding / 2,
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 150 + padding.vertical / 2,
        ),
        delegate: SliverChildBuilderDelegate(
          childCount: items.length,
          (context, index) {
            final item = items.elementAt(index);
            return Padding(
              padding: padding / 2,
              child: itemBuilder(context, item),
            );
          },
        ),
      ),
    );
  }
}
