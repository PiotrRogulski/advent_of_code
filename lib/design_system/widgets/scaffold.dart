// Definition
// ignore_for_file: use_design_system_item_AocScaffold

import 'dart:math';
import 'dart:ui';

import 'package:advent_of_code/design_system/widgets/icon_button.dart';
import 'package:flutter/material.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

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
  static const _titleArmedDistance = _expandedHeight - _collapsedHeight;
  static const _titleCurve = Curves.easeInOut;

  @override
  Widget build(BuildContext context) {
    final shrinkProgress = useState<double>(0);
    final titleScale = lerpDouble(1.25, 0.5, shrinkProgress.value)!;
    final titleWeight = lerpDouble(200, 400, shrinkProgress.value)!;
    final titleWidth = lerpDouble(125, 50, shrinkProgress.value)!;

    final safeArea = MediaQuery.paddingOf(context);

    final scrollController = useScrollController();

    final baseTextStyle = Theme.of(context).textTheme.displayLarge;
    final baseVariations = baseTextStyle?.fontVariations ?? [];
    final textStyle = baseTextStyle?.apply(
      fontSizeFactor: titleScale,
      fontVariations: [
        for (final FontVariation(:axis, :value) in baseVariations)
          .new(axis, axis == 'opsz' ? value * titleScale : value),
        .weight(titleWeight),
        .width(titleWidth),
      ],
    );

    final canPop = ModalRoute.canPopOf(context) ?? false;

    // Definition
    // ignore_for_file: leancode_lint/use_design_system_item
    return Scaffold(
      body: NotificationListener<ScrollMetricsNotification>(
        onNotification: (notification) {
          if (notification.depth == 0) {
            final scaled = notification.metrics.pixels / _titleArmedDistance;
            shrinkProgress.value = switch (scaled) {
              < 0 => -_titleCurve.transform(-atan(scaled) * 2 / pi) / 2,
              _ => _titleCurve.transform(scaled.clamp(0, 1).toDouble()),
            };
          }
          return false;
        },
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverAppBar.large(
              leading: canPop
                  ? AocIconButton(
                      icon: .arrowBack,
                      onPressed: () => Navigator.of(context).maybePop(),
                      iconSize: .large,
                    )
                  : null,
              flexibleSpace: SafeArea(
                child: GestureDetector(
                  onTap: () => scrollController.animateTo(
                    0,
                    duration: const .new(milliseconds: 500),
                    curve: Curves.easeInOutCubicEmphasized,
                  ),
                  behavior: .opaque,
                  child: Center(child: Text(title, style: textStyle)),
                ),
              ),
            ),
            ...bodySlivers,
            SliverToBoxAdapter(child: SizedBox(height: safeArea.bottom)),
          ],
        ),
      ),
    );
  }
}
