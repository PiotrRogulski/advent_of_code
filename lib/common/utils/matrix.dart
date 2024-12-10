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

  Iterable<Iterable<T>> get rows => _values;
  Iterable<Iterable<T>> get columns => _values.zip();
  Iterable<Iterable<T>> get diagonals => [
    for (var c = 0; c < columnCount; c++)
      [
        for (var i = 0; i < rowCount; i++)
          if (maybeAt(i, c + i) case final value?) value,
      ],
    for (var r = 1; r < rowCount; r++)
      [
        for (var i = 0; i < columnCount; i++)
          if (maybeAt(r + i, i) case final value?) value,
      ],
  ];
  Iterable<Iterable<T>> get antiDiagonals => [
    for (var c = 0; c < columnCount; c++)
      [
        for (var i = 0; i < rowCount; i++)
          if (maybeAt(i, c - i) case final value?) value,
      ],
    for (var r = 1; r < rowCount; r++)
      [
        for (var i = 0; i < columnCount; i++)
          if (maybeAt(r - i + columnCount - 1, i) case final value?) value,
      ],
  ];
  Iterable<MatrixCell<T>> get cells =>
      indexes.map((i) => (index: i, value: atIndex(i)));

  T at(int row, int column) => _values[row][column];
  T atIndex(MatrixIndex index) => at(index.row, index.column);

  T? maybeAt(int row, int column) =>
      isInBounds(row, column) ? _values[row][column] : null;
  T? maybeAtIndex(MatrixIndex index) => maybeAt(index.row, index.column);

  MatrixCell<T> cellAt(int row, int column) => (
    index: (row: row, column: column),
    value: at(row, column),
  );
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

  Matrix<T> copy() => Matrix.fromList(_values.map((e) => e.toList()).toList());
}

extension MatrixIndexX on MatrixIndex {
  MatrixIndex operator +(MatrixIndexDelta other) => (
    row: row + other.dr,
    column: column + other.dc,
  );

  MatrixIndexDelta operator -(MatrixIndex other) => (
    dr: row - other.row,
    dc: column - other.column,
  );
}

extension MatrixIndexDeltaX on MatrixIndexDelta {
  MatrixIndexDelta operator *(int factor) => (dr: dr * factor, dc: dc * factor);
}
