import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:more/graph.dart';

typedef _I = ObjectInput<Graph<String, int>>;
typedef _O = NumericOutput<int>;

class Y2023D25 extends DayData<_I> {
  const Y2023D25() : super(2023, 25, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) {
    return _I(
      rawData
          .split('\n')
          .expand((l) {
            final [from, to] = l.split(': ');
            return [for (final t in to.split(' ')) (source: from, target: t)];
          })
          .fold(
            Graph.undirected(),
            (g, e) => g..addEdge(e.source, e.target, value: 1),
          ),
      stringifier:
          (g) =>
              (StringBuffer()
                    ..writeln('Vertices: ${g.vertices.length}')
                    ..writeAll(g.vertices, ' ')
                    ..writeln()
                    ..writeln('Edges: ${g.edges.length}')
                    ..writeAll(
                      g.edges.map((e) => '${e.source} -> ${e.target}'),
                      '\n',
                    ))
                  .toString(),
    );
  }
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    final G = inputData.value.copy();
    final E = G.edges;
    final edgeFrequencies = {
      for (final Edge(:source, :target) in E) _mkPair(source, target): 0,
    };

    for (final V in G.vertices) {
      _bfs(G, V, (a, b) {
        edgeFrequencies[_mkPair(a, b)] = edgeFrequencies[_mkPair(a, b)]! + 1;
      });
    }
    final cutEdges = edgeFrequencies.entries.sortedBy((e) => -e.value).take(3);
    for (final MapEntry(key: (v1, v2)) in cutEdges) {
      G
        ..removeEdge(v1, v2)
        ..removeEdge(v2, v1);
    }
    return _O(G.connected().map((g) => g.vertices.length).product);
  }
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    throw Exception('Merry Christmas!');
  }
}

(String, String) _mkPair(String a, String b) =>
    a.compareTo(b) < 0 ? (a, b) : (b, a);

void _bfs(
  Graph<String, int> G,
  String start,
  void Function(String, String) onEdge,
) {
  final queue = QueueList.from([start]);
  final visited = {start};
  while (queue.isNotEmpty) {
    final v = queue.removeFirst();
    for (final e in G.edgesOf(v)) {
      if (visited.add(e.target)) {
        queue.add(e.target);
        onEdge(v, e.target);
      }
    }
  }
}
