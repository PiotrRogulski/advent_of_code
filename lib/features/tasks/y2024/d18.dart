import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/common/utils/matrix.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:more/more.dart';

typedef _I = ListInput<MatrixIndex>;
typedef _O = StringOutput;

class Y2024D18 extends DayData<_I> {
  const Y2024D18() : super(2024, 18, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) => _I(
    rawData
        .split('\n')
        .map(
          (l) => l
              .split(',')
              .apply(
                (p) => (column: int.parse(p.first), row: int.parse(p.last)),
              ),
        )
        .toList(),
  );
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  static const _memorySize = 71;
  static const _inputLength = 1024;

  @override
  _O runInternal(_I inputData) => _O(
    _findPath(
      inputLength: _inputLength,
      memorySize: _memorySize,
      input: inputData.values,
    )!.cost.toString(),
  );
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  static const _memorySize = 71;

  @override
  _O runInternal(_I inputData) {
    var (l, r) = (0, inputData.values.length);
    while (r - l > 1) {
      final m = (l + r) ~/ 2;
      final path = _findPath(
        inputLength: m,
        memorySize: _memorySize,
        input: inputData.values,
      );
      if (path != null) {
        l = m;
      } else {
        r = m;
      }
    }

    final index = inputData.values[l];
    return _O('${index.column},${index.row}');
  }
}

Path<MatrixIndex, num>? _findPath({
  required int inputLength,
  required int memorySize,
  required List<MatrixIndex> input,
}) => input
    .take(inputLength)
    .fold(
      Matrix.fromList(
        List.generate(memorySize, (_) => List.filled(memorySize, true)),
      ),
      (m, index) => m..setIndex(index, false),
    )
    .apply(
      (memory) =>
          DijkstraSearchIterable(
            startVertices: [(row: 0, column: 0)],
            successorsOf:
                (v) => [
                  v + (dr: -1, dc: 0),
                  v + (dr: 1, dc: 0),
                  v + (dr: 0, dc: -1),
                  v + (dr: 0, dc: 1),
                ].where(memory.isIndexInBounds).where(memory.atIndex),
            targetPredicate:
                (v) => v == (row: memorySize - 1, column: memorySize - 1),
          ).lastOrNull,
    );
