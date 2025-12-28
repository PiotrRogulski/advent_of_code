import 'dart:math';

import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/common/utils/matrix.dart';
import 'package:advent_of_code/design_system/padding.dart';
import 'package:advent_of_code/design_system/widgets/checkbox_list_tile.dart';
import 'package:advent_of_code/design_system/widgets/expansion_card.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:more/collection.dart' hide IndexedIterableExtension;

class SliverDayInputView extends StatelessWidget {
  const SliverDayInputView({
    super.key,
    required this.inputData,
    required this.label,
  });

  final PartInput inputData;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: DayInputView(inputData: inputData, label: label),
    );
  }
}

class DayInputView extends HookWidget {
  const DayInputView({super.key, required this.inputData, required this.label});

  final PartInput inputData;
  final String label;

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final wrapText = useState(false);

    return AocExpansionCard(
      title: s.day_inputData(label: label),
      aboveBody: AocCheckboxListTile(
        value: wrapText.value,
        onChanged: (value) => wrapText.value = value!,
        title: s.day_inputData_wrap,
        dense: true,
      ),
      body: SingleChildScrollView(
        key: PageStorageKey(inputData),
        scrollDirection: wrapText.value ? .vertical : .horizontal,
        padding: const AocEdgeInsets.all(.medium),
        child: DefaultTextStyle.merge(
          style: const .new(fontFamily: 'JetBrains Mono'),
          child: switch (inputData) {
            RawStringInput(:final value) => _TextData(.new(text: value)),
            ListInput(:final values) => _ListData(values: values),
            MatrixInput(:final matrix, dense: true) => _ListData(
              values: matrix.rows.map((row) => row.join()).toList(),
            ),
            MatrixInput(:final matrix) => _MatrixData(matrix: matrix),
            ObjectInput(:final toRichString) => _TextData(
              TextSpan(text: toRichString()),
            ),
          },
        ),
      ),
    );
  }
}

class _MatrixData<T> extends HookWidget {
  const _MatrixData({required this.matrix});

  final Matrix<T> matrix;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final tableSpan = useFuture(
      useMemoized(() => compute(_computeLayout, (matrix, colors)), [
        matrix,
        colors,
      ]),
    ).data;

    if (tableSpan == null) {
      return const SizedBox();
    }

    return _TextData(tableSpan);
  }

  TextSpan _computeLayout((Matrix<T> matrix, ColorScheme colors) data) {
    final (matrix, colors) = data;

    final itemStrings = [
      for (final row in matrix.rows) [for (final e in row) '$e'],
    ];

    final indexStyle = TextStyle(color: colors.primary, fontWeight: .bold);

    final cells = [
      [
        const TextSpan(),
        for (var i = 0; i < matrix.columnCount; i++)
          TextSpan(text: '$i', style: indexStyle),
      ],
      for (final (index, row) in itemStrings.indexed)
        [
          TextSpan(text: '$index', style: indexStyle),
          for (final e in row) TextSpan(text: e),
        ],
    ];

    final columnWidths = [
      for (final column in cells.zip())
        max(2, column.map((e) => e.text?.length ?? 0).max),
    ];

    final alignedCells = [
      for (final row in cells)
        [
          for (final (cell, width) in (row, columnWidths).zip())
            TextSpan(
              text: ' ${cell.toPlainText().padLeft(width)} ',
              style: cell.style,
            ),
        ],
    ];

    return .new(
      children: alignedCells
          .separatedBy(() => const [.new(text: '\n')])
          .flattenedToList,
    );
  }
}

class _TextData extends StatelessWidget {
  const _TextData(this.textSpan);

  final TextSpan textSpan;

  @override
  Widget build(BuildContext context) {
    // No dynamic weight here
    // ignore: leancode_lint/use_design_system_item
    return SelectionArea(child: Text.rich(textSpan));
  }
}

class _ListData<T> extends StatelessWidget {
  const _ListData({required this.values});

  final List<T> values;

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final indexPartLength = s
        .day_inputData_matrixIndex(index: values.length)
        .length;

    return SelectionArea(
      // No dynamic weight here
      // ignore: leancode_lint/use_design_system_item
      child: Text.rich(
        TextSpan(
          children: [
            for (final (index, value) in values.indexed)
              TextSpan(
                children: [
                  if (index > 0) const TextSpan(text: '\n'),
                  TextSpan(
                    text: s
                        .day_inputData_matrixIndex(index: index)
                        .padLeft(indexPartLength),
                    style: .new(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  TextSpan(text: value.toString()),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
