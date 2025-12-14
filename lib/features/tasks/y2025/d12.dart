import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/common/utils/matrix.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:characters/characters.dart';
import 'package:collection/collection.dart';
import 'package:more/more.dart';

typedef _Region = ({int width, int length, List<int> quantities});
typedef _I =
    ObjectInput<({List<Matrix<String>> shapes, List<_Region> regions})>;
typedef _O = NumericOutput<int>;

class Y2025D12 extends DayData<_I> {
  const Y2025D12() : super(2025, 12, parts: const {1: _P1()});

  @override
  _I parseInput(String rawData) => .new(
    rawData
        .split('\n\n')
        .apply(
          (l) => (
            shapes: l
                .skipLast(1)
                .map(
                  (l) => l
                      .split('\n')
                      .skip(1)
                      .map((l) => l.characters.toList())
                      .toList()
                      .apply(Matrix.fromList),
                )
                .toList(),
            regions: l.last
                .split('\n')
                .map(
                  (l) => l
                      .split(RegExp('x|(: )'))
                      .apply(
                        (l) => (
                          width: int.parse(l[0]),
                          length: int.parse(l[1]),
                          quantities: l[2].split(' ').map(int.parse).toList(),
                        ),
                      ),
                )
                .toList(),
          ),
        ),
  );
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(
    inputData.value.regions.count(
      (r) =>
          r.length * r.width >=
          r.quantities
              .mapIndexed(
                (i, q) => inputData.value.shapes[i].apply(
                  (s) => s.rowCount * s.columnCount * q,
                ),
              )
              .sum,
    ),
  );
}
