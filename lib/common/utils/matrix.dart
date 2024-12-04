import 'package:equatable/equatable.dart';
import 'package:more/collection.dart';

typedef MatrixCell<T> = ({int row, int column, T cell});

class Matrix<T> with EquatableMixin {
  Matrix.fromList(this._values)
    : assert(_values.map((e) => e.length).toSet().length == 1);

  final List<List<T>> _values;

  int get rowCount => _values.length;

  int get columnCount => _values.first.length;

  ({int columns, int rows}) get size => (columns: columnCount, rows: rowCount);

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
  Iterable<MatrixCell<T>> get cells => indexes.map(
    (i) => (row: i.row, column: i.column, cell: _values[i.row][i.column]),
  );

  T at(int row, int column) => _values[row][column];

  T? maybeAt(int row, int column) =>
      isIndexInBounds(row, column) ? _values[row][column] : null;

  void set(int row, int column, T value) => _values[row][column] = value;

  bool isIndexInBounds(int row, int column) =>
      row >= 0 && row < rowCount && column >= 0 && column < columnCount;

  @override
  List<Object?> get props => [_values];

  Iterable<({int row, int column})> get indexes sync* {
    for (var i = 0; i < _values.length; i++) {
      for (var j = 0; j < _values[i].length; j++) {
        yield (row: i, column: j);
      }
    }
  }

  Matrix<T> copy() => Matrix.fromList(_values.map((e) => e.toList()).toList());
}
