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
  const Y2023D6() : super(year: 2023, day: 6);

  @override
  _I parseInput(String rawData) {
    return ListInput(
      rawData
          .split('\n')
          .map((e) => e.split(RegExp(' +')))
          .zip()
          .skip(1)
          .map(
            (l) => (
              time: int.parse(l.first),
              distance: int.parse(l.last),
            ),
          )
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
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    return NumericOutput(
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
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    return NumericOutput(
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
}
