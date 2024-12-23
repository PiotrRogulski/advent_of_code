import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:more/more.dart';

typedef _I = ListInput<(String, String)>;
typedef _O = StringOutput;

typedef _Network = Graph<String, int>;

class Y2024D23 extends DayData<_I> {
  const Y2024D23() : super(2024, 23, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) => _I(
    rawData.split('\n').map((l) => Tuple2.fromList(l.split('-'))).toList(),
  );
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) => _O(
    inputData
        .asNetwork()
        .apply(_generateTriples)
        .count((vs) => [vs.$1, vs.$2, vs.$3].any((e) => e.startsWith('t')))
        .toString(),
  );
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) => _O(
    inputData
        .asNetwork()
        .apply(_findMaximalClique)
        .sortedBy((e) => e)
        .join(','),
  );
}

Iterable<(String, String, String)> _generateTriples(_Network graph) =>
    graph.vertices
        .expand(
          (v) => graph
              .neighboursOf(v)
              .combinations(2)
              .where((n) => graph.getEdge(n.first, n.last) != null)
              .map((n) => Tuple3.fromList([v, ...n]..sort())),
        )
        .toSet();

Set<String> _findMaximalClique(_Network graph) {
  Set<String>? bronKerbosch(Set<String> r, Set<String> p, Set<String> x) {
    if (p.isEmpty && x.isEmpty) {
      return r;
    }

    Set<String>? maxClique;
    for (final v in p.toSet()) {
      final neighbors = graph.neighboursOf(v).toSet();
      final clique = bronKerbosch(r | {v}, p & neighbors, x & neighbors);
      if (clique != null &&
          (maxClique == null || clique.length > maxClique.length)) {
        maxClique = clique;
      }
      p.remove(v);
      x.add(v);
    }
    return maxClique;
  }

  return bronKerbosch({}, graph.vertices.toSet(), {})!;
}

extension on _I {
  _Network asNetwork() => values.fold(
    Graph<String, int>.undirected(),
    (g, p) => g..addEdge(p.$1, p.$2, value: 1),
  );
}
