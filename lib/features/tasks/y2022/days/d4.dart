import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';

typedef _Range = ({int from, int to});
typedef _I = ListInput<(_Range, _Range)>;
typedef _O = NumericOutput<int>;

class Y2022D4 extends DayData<_I> {
  const Y2022D4() : super(2022, 4, parts: const {1: _P1(), 2: _P2()});

  static final _lineRegex = RegExp(r'^(\d+)-(\d+),(\d+)-(\d+)$');

  @override
  _I parseInput(String rawData) {
    return ListInput(
      rawData
          .split('\n')
          .map(_lineRegex.firstMatch)
          .nonNulls
          .map(
            (m) => m.groups([1, 2, 3, 4]).nonNulls.map(int.parse).toList(),
          )
          .map((l) => ((from: l[0], to: l[1]), (from: l[2], to: l[3])))
          .toList(),
    );
  }
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    return NumericOutput(
      inputData.values.where((t) => _containsOther(t.$1, t.$2)).length,
    );
  }

  bool _containsOther(_Range range1, _Range range2) {
    return range1.from >= range2.from && range1.to <= range2.to ||
        range2.from >= range1.from && range2.to <= range1.to;
  }
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    return NumericOutput(
      inputData.values.where((t) => _hasIntersection(t.$1, t.$2)).length,
    );
  }

  bool _hasIntersection(_Range range1, _Range range2) {
    return range1.from <= range2.to && range1.to >= range2.from;
  }
}
