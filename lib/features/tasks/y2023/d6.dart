import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:more/collection.dart';

class const _Race({required final int time, required final int distance});

typedef _I = ListInput<_Race>;
typedef _O = NumericOutput<int>;

class const Y2023D6() extends DayData<_I> {
  this : super(2023, 6, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) => .new(
    rawData
        .split('\n')
        .map((e) => e.split(RegExp(' +')))
        .zip()
        .skip(1)
        .map((l) => _Race(time: .parse(l.first), distance: .parse(l.last)))
        .toList(),
  );
}

class const _P1() extends PartImplementation<_I, _O> {
  this : super(completed: true);

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

class const _P2() extends PartImplementation<_I, _O> {
  this : super(completed: true);

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
