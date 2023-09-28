import 'dart:math';

import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/gen/fonts.gen.dart';
import 'package:flutter/material.dart';

class SliverPartInputView extends StatelessWidget {
  const SliverPartInputView({
    super.key,
    required this.inputData,
  });

  final PartInput inputData;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SliverToBoxAdapter(
      child: Card(
        margin: const EdgeInsets.all(16),
        child: ExpansionTile(
          title: const Text('Input data'),
          maintainState: true,
          expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              margin: const EdgeInsets.only(
                left: 8,
                right: 8,
                bottom: 8,
              ),
              color: colors.surface,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: colors.outline,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(16)),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(16),
                child: DefaultTextStyle.merge(
                  style: const TextStyle(
                    fontFamily: FontFamily.jetBrainsMono,
                    height: 1.2,
                  ),
                  child: switch (inputData) {
                    RawStringInput(:final value) =>
                      _RawStringData(value: value),
                    ListInput(:final values) => _ListData(values: values),
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RawStringData extends StatelessWidget {
  const _RawStringData({
    required this.value,
  });

  final String value;

  @override
  Widget build(BuildContext context) {
    return SelectableText(value);
  }
}

class _ListData<T> extends StatelessWidget {
  const _ListData({
    required this.values,
  });

  final List<T> values;

  @override
  Widget build(BuildContext context) {
    final indexPartLength =
        (log(values.length.clamp(1, double.infinity)) * log10e).ceil();
    return SelectionArea(
      child: Text.rich(
        TextSpan(
          children: [
            for (final (index, value) in values.indexed)
              TextSpan(
                children: [
                  if (index > 0) const TextSpan(text: '\n'),
                  TextSpan(
                    text: '$index: '.padLeft(indexPartLength + 2),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  TextSpan(text: '$value'),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
