import 'dart:math';

import 'package:advent_of_code/design_system/widgets/expansion_card.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SliverDayInputView extends StatelessWidget {
  const SliverDayInputView({
    super.key,
    required this.inputData,
  });

  final PartInput inputData;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: DayInputView(
        inputData: inputData,
      ),
    );
  }
}

class DayInputView extends HookWidget {
  const DayInputView({
    super.key,
    required this.inputData,
  });

  final PartInput inputData;

  @override
  Widget build(BuildContext context) {
    final wrapText = useState(false);

    return AocExpansionCard(
      title: 'Input data',
      trailing: Row(
        children: [
          Text(
            'Wrap',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          Checkbox(
            value: wrapText.value,
            onChanged: (value) => wrapText.value = value!,
          ),
        ],
      ),
      child: SingleChildScrollView(
        key: PageStorageKey(inputData),
        scrollDirection: wrapText.value ? Axis.vertical : Axis.horizontal,
        padding: const EdgeInsets.all(16),
        child: DefaultTextStyle.merge(
          style: const TextStyle(
            fontFamily: FontFamily.jetBrainsMono,
            height: 1.2,
          ),
          child: switch (inputData) {
            RawStringInput(:final value) => _RawStringData(value: value),
            ListInput(:final values) => _ListData(values: values),
            ObjectInput(:final toRichString) => _RawStringData(
                value: toRichString(),
              ),
          },
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
