import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:more/math.dart';

typedef _Node = ({String left, String right});
typedef _Map = ({List<_Move> moves, Map<String, _Node> nodes});

typedef _I = ObjectInput<_Map>;
typedef _O = NumericOutput<int>;

class Y2023D8 extends DayData<_I> {
  const Y2023D8() : super(2023, 8, parts: const {1: _P1(), 2: _P2()});

  static final _nodeRegex =
      RegExp(r'^(?<label>\w+) = \((?<left>\w+), (?<right>\w+)\)$');

  @override
  _I parseInput(String rawData) {
    return ObjectInput(
      rawData
          .split('\n\n')
          .apply((l) => (moveString: l.first, nodeString: l.last))
          .apply(
            (t) => (
              moves: t.moveString.split('').map(_Move.fromSymbol).toList(),
              nodes: Map.fromEntries(
                t.nodeString
                    .split('\n')
                    .map(_nodeRegex.firstMatch)
                    .nonNulls
                    .map(
                      (m) => MapEntry(
                        m.namedGroup('label')!,
                        (
                          left: m.namedGroup('left')!,
                          right: m.namedGroup('right')!,
                        ),
                      ),
                    ),
              ),
            ),
          ),
    );
  }
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    return NumericOutput(
      _findPathLength(
        inputData.value,
        'AAA',
        isAtEnd: (node) => node == 'ZZZ',
      ),
    );
  }
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    return NumericOutput(
      inputData.value.nodes.keys
          .where((n) => n.endsWith('A'))
          .map(
            (node) => _findPathLength(
              inputData.value,
              node,
              isAtEnd: (node) => node.endsWith('Z'),
            ),
          )
          .lcm(),
    );
  }
}

enum _Move {
  left('L'),
  right('R');

  const _Move(this.symbol);

  factory _Move.fromSymbol(String s) => values.firstWhere((v) => v.symbol == s);

  final String symbol;
}

int _findPathLength(
  _Map map,
  String start, {
  required bool Function(String node) isAtEnd,
}) {
  var node = start;
  var count = 0;
  var moveIndex = 0;
  while (!isAtEnd(node)) {
    final move = map.moves[moveIndex];
    final connections = map.nodes[node]!;
    node = move == _Move.left ? connections.left : connections.right;
    count++;
    moveIndex = (moveIndex + 1) % map.moves.length;
  }
  return count;
}
