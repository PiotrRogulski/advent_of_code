import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';

typedef _Range = ({int from, int to});
typedef _I = ListInput<(_Range, _Range)>;
typedef _O = NumericOutput<int>;

class Y2022D4 extends DayData<_I> {
  const Y2022D4() : super(year: 2022, day: 4);

  static final _lineRegex = RegExp(r'^(\d+)-(\d+),(\d+)-(\d+)$');

  @override
  _I parseInput(String rawData) {
    return ListInput(
      rawData
          .trim()
          .split('\n')
          .map(_lineRegex.firstMatch)
          .cast<RegExpMatch>()
          .map(
            (m) =>
                m.groups([1, 2, 3, 4]).cast<String>().map(int.parse).toList(),
          )
          .map((l) => ((from: l[0], to: l[1]), (from: l[2], to: l[3])))
          .toList(),
    );
  }

  @override
  Map<int, PartImplementation<_I, _O>> get parts => {
        1: const _P1(),
        2: const _P2(),
      };
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1();

  @override
  bool get completed => true;

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
  const _P2();

  @override
  bool get completed => true;

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