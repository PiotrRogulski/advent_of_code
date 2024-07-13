import 'package:advent_of_code/design_system/icons.dart';
import 'package:advent_of_code/design_system/widgets/icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AocScaffold extends HookWidget {
  const AocScaffold({
    super.key,
    required this.title,
    this.bodySlivers = const [],
  });

  final String title;
  final List<Widget> bodySlivers;

  static const _expandedHeight = 152.0;
  static const _collapsedHeight = 64.0;

  @override
  Widget build(BuildContext context) {
    final titleScale = useState<double>(1);

    final safeArea = MediaQuery.paddingOf(context);

    final scrollController = useScrollController();

    final baseTextStyle = Theme.of(context).textTheme.displayLarge;
    final baseVariations = baseTextStyle?.fontVariations ?? <FontVariation>[];
    final textStyle = baseTextStyle?.apply(
      fontSizeFactor: titleScale.value,
      fontVariations: [
        for (final FontVariation(:axis, :value) in baseVariations)
          FontVariation(
            axis,
            axis == 'opsz' ? value * titleScale.value : value,
          ),
      ],
    );

    final canPop = ModalRoute.canPopOf(context) ?? false;

    // ignore: use_design_system_item_AocScaffold
    return Scaffold(
      body: NotificationListener(
        onNotification: (notification) {
          if (notification
              case ScrollMetricsNotification(:final metrics, depth: 0)) {
            final newValue =
                (metrics.pixels / (_expandedHeight - _collapsedHeight))
                    .clamp(0, 1)
                    .toDouble();
            titleScale.value = 1 - Curves.easeInOut.transform(newValue) / 2;
          }
          return false;
        },
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverAppBar.large(
              leading: canPop
                  ? AocIconButton(
                      icon: AocIcons.arrow_back,
                      onPressed: () => Navigator.of(context).pop(),
                      iconSize: 24,
                    )
                  : null,
              flexibleSpace: SafeArea(
                child: GestureDetector(
                  onTap: () => scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOutCubicEmphasized,
                  ),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Text(
                      title,
                      style: textStyle,
                    ),
                  ),
                ),
              ),
            ),
            ...bodySlivers,
            SliverToBoxAdapter(
              child: SizedBox(height: safeArea.bottom),
            ),
          ],
        ),
      ),
    );
  }
}
