import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/common/utils/matrix.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:characters/characters.dart';
import 'package:collection/collection.dart';
import 'package:more/more.dart';

class const _Region({
  required final int width,
  required final int length,
  required final List<int> quantities,
});
class const _Input({
  required final List<Matrix<String>> shapes,
  required final List<_Region> regions,
});
typedef _I = ObjectInput<_Input>;
typedef _O = NumericOutput<int>;

class const Y2025D12() extends DayData<_I> {
  this : super(2025, 12, parts: const {1: _P1()});

  @override
  _I parseInput(String rawData) => .new(
    rawData
        .split('\n\n')
        .apply(
          (l) => .new(
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
                        (l) => _Region(
                          width: .parse(l[0]),
                          length: .parse(l[1]),
                          quantities: l[2].split(' ').map(int.parse).toList(),
                        ),
                      ),
                )
                .toList(),
          ),
        ),
  );
}

class const _P1() extends PartImplementation<_I, _O> {
  this : super(completed: true);

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
