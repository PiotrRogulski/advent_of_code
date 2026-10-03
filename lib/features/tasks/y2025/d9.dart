import 'dart:math';

import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:more/more.dart';

class const _Point(final int x, final int y);
typedef _I = ListInput<_Point>;
typedef _O = NumericOutput<int>;

class const Y2025D9() extends DayData<_I> {
  this : super(2025, 9, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) => .new(
    rawData
        .split('\n')
        .map(
          (l) => l
              .split(',')
              .map(int.parse)
              .toList()
              .apply((l) => _Point(l[0], l[1])),
        )
        .toList(),
  );
}

class const _P1() extends PartImplementation<_I, _O> {
  this : super(completed: true);

  @override
  _O runInternal(_I inputData) =>
      .new(inputData.values.combinations(2).map((p) => _area(p[0], p[1])).max);
}

class const _P2() extends PartImplementation<_I, _O> {
  this : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(
    inputData.values
        .followedBy([inputData.values.first])
        .pairwise()
        .map((p) => _bounds(p.$1, p.$2))
        .toList()
        .apply(
          (edges) => inputData.values
              .combinations(2)
              .map(
                (p) => (bounds: _bounds(p[0], p[1]), area: _area(p[0], p[1])),
              )
              .sortedBy((e) => -e.area)
              .firstWhere(
                (rect) => edges.none(
                  (edgeBounds) =>
                      rect.bounds.minX < edgeBounds.maxX &&
                      rect.bounds.maxX > edgeBounds.minX &&
                      rect.bounds.minY < edgeBounds.maxY &&
                      rect.bounds.maxY > edgeBounds.minY,
                ),
              )
              .area,
        ),
  );
}

int _area(_Point a, _Point b) =>
    ((a.x - b.x).abs() + 1) * ((a.y - b.y).abs() + 1);

({int minX, int maxX, int minY, int maxY}) _bounds(_Point a, _Point b) => (
  minX: min(a.x, b.x),
  maxX: max(a.x, b.x),
  minY: min(a.y, b.y),
  maxY: max(a.y, b.y),
);
