import 'package:advent_of_code/common/widgets/breakpoint_selector.dart';
import 'package:advent_of_code/design_system/padding.dart';
import 'package:advent_of_code/design_system/unit.dart';
import 'package:custom_adaptive_scaffold/custom_adaptive_scaffold.dart';
import 'package:material_ui/material_ui.dart';

class const SliverAdaptiveList<T>({
  super.key,
  required final Iterable<T> items,
  required final Widget Function(BuildContext, T) listItemBuilder,
  required final Widget Function(BuildContext, T) gridItemBuilder,
  final Widget Function(BuildContext, Widget)? itemWrapper,
  final AocEdgeInsets padding = const .all(.medium),
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BreakpointSelector(
      builders: {
        Breakpoints.small: (context) => _SliverList(
          items: items,
          itemBuilder: listItemBuilder,
          padding: padding,
          itemWrapper: itemWrapper ?? (context, child) => child,
        ),
        null: (context) => _SliverGrid(
          items: items,
          itemBuilder: gridItemBuilder,
          padding: padding,
          itemWrapper: itemWrapper ?? (context, child) => child,
        ),
      },
    );
  }
}

class const _SliverList<T>({
  required final Iterable<T> items,
  required final Widget Function(BuildContext, T) itemBuilder,
  required final AocEdgeInsets padding,
  required final Widget Function(BuildContext, Widget) itemWrapper,
}) extends StatelessWidget {
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

class const _SliverGrid<T>({
  required final Iterable<T> items,
  required final Widget Function(BuildContext, T) itemBuilder,
  required final AocEdgeInsets padding,
  required final Widget Function(BuildContext, Widget) itemWrapper,
}) extends StatelessWidget {
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
