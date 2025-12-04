import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:more/collection.dart';

typedef MatrixIndex = ({int row, int column});
typedef MatrixCell<T> = ({MatrixIndex index, T value});
typedef MatrixIndexDelta = ({int dr, int dc});
typedef MatrixSize = ({int columns, int rows});

class Matrix<T> with EquatableMixin {
  Matrix.fromList(this._values)
    : assert(_values.map((e) => e.length).toSet().length == 1);

  final List<List<T>> _values;

  int get rowCount => _values.length;

  int get columnCount => _values.first.length;

  MatrixSize get size => (columns: columnCount, rows: rowCount);

  List<List<T>> get rows => UnmodifiableListView(_values);
  List<List<T>> get columns => _values.zip().toList();
  Iterable<Iterable<T>> get diagonals => [
    for (var c = 0; c < columnCount; c++)
      [for (var i = 0; i < rowCount; i++) ?maybeAt(i, c + i)],
    for (var r = 1; r < rowCount; r++)
      [for (var i = 0; i < columnCount; i++) ?maybeAt(r + i, i)],
  ];
  Iterable<Iterable<T>> get antiDiagonals => [
    for (var c = 0; c < columnCount; c++)
      [for (var i = 0; i < rowCount; i++) ?maybeAt(i, c - i)],
    for (var r = 1; r < rowCount; r++)
      [
        for (var i = 0; i < columnCount; i++)
          ?maybeAt(r - i + columnCount - 1, i),
      ],
  ];
  Iterable<MatrixCell<T>> get cells =>
      indexes.map((i) => (index: i, value: atIndex(i)));

  T at(int row, int column) => _values[row][column];
  T atIndex(MatrixIndex index) => at(index.row, index.column);

  T? maybeAt(int row, int column) =>
      isInBounds(row, column) ? _values[row][column] : null;
  T? maybeAtIndex(MatrixIndex index) => maybeAt(index.row, index.column);

  MatrixCell<T> cellAt(int row, int column) =>
      (index: (row: row, column: column), value: at(row, column));
  MatrixCell<T> cellAtIndex(MatrixIndex index) =>
      cellAt(index.row, index.column);

  MatrixCell<T>? maybeCellAt(int row, int column) =>
      isInBounds(row, column) ? cellAt(row, column) : null;
  MatrixCell<T>? maybeCellAtIndex(MatrixIndex index) =>
      maybeCellAt(index.row, index.column);

  void set(int row, int column, T value) => _values[row][column] = value;
  void setIndex(MatrixIndex index, T value) =>
      set(index.row, index.column, value);

  bool isInBounds(int row, int column) =>
      row >= 0 && row < rowCount && column >= 0 && column < columnCount;
  bool isIndexInBounds(MatrixIndex index) =>
      isInBounds(index.row, index.column);

  @override
  List<Object?> get props => [_values];

  Iterable<MatrixIndex> get indexes sync* {
    for (var i = 0; i < _values.length; i++) {
      for (var j = 0; j < _values[i].length; j++) {
        yield (row: i, column: j);
      }
    }
  }

  MatrixIndex indexOf(T value) =>
      indexes.firstWhere((i) => atIndex(i) == value);

  Matrix<T> copy() => .fromList(_values.map((e) => e.toList()).toList());

  Iterable<MatrixCell<T>> neighborsOf(int row, int column) =>
      neighborsOfIndex((row: row, column: column));

  Iterable<MatrixCell<T>> neighborsOfIndex(MatrixIndex index) => [
    index.up,
    index.down,
    index.left,
    index.right,
    index.up.left,
    index.down.right,
    index.up.right,
    index.down.left,
  ].where(isIndexInBounds).map(cellAtIndex);
}

extension MatrixIndexX on MatrixIndex {
  MatrixIndex operator +(MatrixIndexDelta other) =>
      (row: row + other.dr, column: column + other.dc);

  MatrixIndexDelta operator -(MatrixIndex other) =>
      (dr: row - other.row, dc: column - other.column);

  MatrixIndex get up => (row: row - 1, column: column);
  MatrixIndex get down => (row: row + 1, column: column);
  MatrixIndex get left => (row: row, column: column - 1);
  MatrixIndex get right => (row: row, column: column + 1);
}

extension MatrixIndexDeltaX on MatrixIndexDelta {
  MatrixIndexDelta operator *(int factor) => (dr: dr * factor, dc: dc * factor);
  MatrixIndexDelta operator -() => (dr: -dr, dc: -dc);
}
