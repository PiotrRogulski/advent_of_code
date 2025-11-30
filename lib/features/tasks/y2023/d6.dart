import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:more/collection.dart';

typedef _Race = ({int time, int distance});

typedef _I = ListInput<_Race>;
typedef _O = NumericOutput<int>;

class Y2023D6 extends DayData<_I> {
  const Y2023D6() : super(2023, 6, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) => .new(
    rawData
        .split('\n')
        .map((e) => e.split(RegExp(' +')))
        .zip()
        .skip(1)
        .map((l) => (time: int.parse(l.first), distance: int.parse(l.last)))
        .toList(),
  );
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(
    inputData.values
        .map(
          (r) => Iterable.generate(
            r.time + 1,
            (time) => (time: time, distance: time * (r.time - time)),
          ).where((d) => d.distance > r.distance),
        )
        .map((e) => e.length)
        .product,
  );
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(
    inputData.values
        .apply(
          (values) => (
            time: int.parse(values.map((e) => e.time).join()),
            distance: int.parse(values.map((e) => e.distance).join()),
          ),
        )
        .apply(
          (r) => Iterable.generate(
            r.time + 1,
            (time) => (time: time, distance: time * (r.time - time)),
          ).where((d) => d.distance > r.distance),
        )
        .length,
  );
}
