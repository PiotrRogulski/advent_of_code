import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';

typedef _I = ObjectInput<Map<String, List<String>>>;
typedef _O = NumericOutput<int>;

class Y2025D11 extends DayData<_I> {
  const Y2025D11() : super(2025, 11, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) => .new(
    .fromEntries(
      rawData
          .split('\n')
          .map(
            (l) => l.split(': ').apply((e) => .new(e.first, e.last.split(' '))),
          ),
    ),
  );
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(_findPaths(inputData.value));

  int _findPaths(Map<String, List<String>> graph) {
    var pathCount = 0;

    void dfs(String current, List<String> currentPath) {
      currentPath.add(current);

      if (current == 'out') {
        pathCount++;
      } else if (graph[current] case final neighbors?) {
        for (final neighbor in neighbors) {
          dfs(neighbor, currentPath);
        }
      }

      currentPath.removeLast();
    }

    dfs('you', []);

    return pathCount;
  }
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(_findPaths(inputData.value));

  int _findPaths(Map<String, List<String>> graph) {
    final memo = <(String, String), int>{};

    int countPaths(String start, String end) {
      if (start == end) {
        return 1;
      }

      return memo[(start, end)] ??=
          graph[start]?.map((neighbor) => countPaths(neighbor, end)).sum ?? 0;
    }

    final dacFftCount =
        countPaths('svr', 'dac') *
        countPaths('dac', 'fft') *
        countPaths('fft', 'out');

    final fftDacCount =
        countPaths('svr', 'fft') *
        countPaths('fft', 'dac') *
        countPaths('dac', 'out');

    return dacFftCount + fftDacCount;
  }
}
