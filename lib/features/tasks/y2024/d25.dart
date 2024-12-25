import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:characters/characters.dart';
import 'package:more/more.dart';

typedef _I = ObjectInput<({List<List<int>> locks, List<List<int>> keys})>;
typedef _O = StringOutput;

class Y2024D25 extends DayData<_I> {
  const Y2024D25() : super(2024, 25, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) => _I(
    rawData
        .split('\n\n')
        .partition((s) => s.startsWith('#'))
        .apply(
          (p) => (
            locks: p.falsey.map(_parseElement).toList(),
            keys: p.truthy.map(_parseElement).toList(),
          ),
        ),
  );
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) => _O(
    (inputData.value.locks, inputData.value.keys)
        .product()
        .where((p) => p.zip().every((p) => p.$1 + p.$2 < 6))
        .length
        .toString(),
  );
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) => const _O('Merry Christmas!');
}

List<int> _parseElement(String element) =>
    element
        .split('\n')
        .map((l) => l.characters)
        .zip()
        .map((col) => col.count((c) => c == '#') - 1)
        .toList();
