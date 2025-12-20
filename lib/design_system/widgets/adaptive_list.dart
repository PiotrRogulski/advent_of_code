import 'package:advent_of_code/common/widgets/breakpoint_selector.dart';
import 'package:advent_of_code/design_system/padding.dart';
import 'package:advent_of_code/design_system/unit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';

class SliverAdaptiveList<T> extends StatelessWidget {
  const SliverAdaptiveList({
    super.key,
    required this.items,
    required this.listItemBuilder,
    required this.gridItemBuilder,
    this.itemWrapper,
    this.padding = const .all(.medium),
  });

  final Iterable<T> items;
  final Widget Function(BuildContext, T) listItemBuilder;
  final Widget Function(BuildContext, T) gridItemBuilder;
  final Widget Function(BuildContext, Widget)? itemWrapper;
  final AocEdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return BreakpointSelector(
      builders: {
        Breakpoints.small: (_) => _SliverList(
          items: items,
          itemBuilder: listItemBuilder,
          padding: padding,
          itemWrapper: itemWrapper ?? (_, child) => child,
        ),
        null: (_) => _SliverGrid(
          items: items,
          itemBuilder: gridItemBuilder,
          padding: padding,
          itemWrapper: itemWrapper ?? (_, child) => child,
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
    required this.itemWrapper,
  });

  final Iterable<T> items;
  final Widget Function(BuildContext, T) itemBuilder;
  final AocEdgeInsets padding;
  final Widget Function(BuildContext, Widget) itemWrapper;

  @override
  Widget build(BuildContext context) {
    return AocSliverPadding(
      padding: padding,
      sliver: SliverList.separated(
        itemCount: items.length,
        itemBuilder: (context, index) => itemWrapper(
          context,
          Builder(
            builder: (context) => itemBuilder(context, items.elementAt(index)),
          ),
        ),
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
    required this.itemWrapper,
  });

  final Iterable<T> items;
  final Widget Function(BuildContext, T) itemBuilder;
  final AocEdgeInsets padding;
  final Widget Function(BuildContext, Widget) itemWrapper;

  static final baseItemSize = AocUnit.xlarge * 4;

  @override
  Widget build(BuildContext context) {
    return AocSliverPadding(
      padding: padding / 2,
      sliver: SliverLayoutBuilder(
        builder: (context, constraints) {
          final hPadding = padding.horizontal / 2;
          final itemWidth = baseItemSize.toDouble() + hPadding;
          final itemsPerRow = constraints.crossAxisExtent ~/ itemWidth;
          final rowFilledExactly = constraints.crossAxisExtent % itemWidth == 0;
          final rows = (items.length / itemsPerRow).ceil();
          return SliverMainAxisGroup(
            slivers: [
              for (var i = 0; i <= rows; i++)
                SliverCrossAxisGroup(
                  slivers: [
                    for (final item
                        in items.skip(i * itemsPerRow).take(itemsPerRow))
                      SliverConstrainedCrossAxis(
                        maxExtent: itemWidth,
                        sliver: AocSliverPadding(
                          padding: padding / 2,
                          sliver: SliverToBoxAdapter(
                            child: SizedBox(
                              height: baseItemSize,
                              width: itemWidth,
                              child: itemWrapper(
                                context,
                                Builder(
                                  builder: (context) =>
                                      itemBuilder(context, item),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (!rowFilledExactly)
                      const SliverCrossAxisExpanded(
                        flex: 1,
                        sliver: SliverToBoxAdapter(),
                      ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}
