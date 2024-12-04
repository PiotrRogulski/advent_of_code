import 'package:equatable/equatable.dart';
import 'package:more/collection.dart';

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
          if (isIndexInBounds(i, c + i)) _values[i][c + i],
      ],
    for (var r = 1; r < rowCount; r++)
      [
        for (var i = 0; i < columnCount; i++)
          if (isIndexInBounds(r + i, i)) _values[r + i][i],
      ],
  ];
  Iterable<Iterable<T>> get antiDiagonals => [
    for (var c = 0; c < columnCount; c++)
      [
        for (var i = 0; i < rowCount; i++)
          if (isIndexInBounds(i, c - i)) _values[i][c - i],
      ],
    for (var r = 1; r < rowCount; r++)
      [
        for (var i = 0; i < columnCount; i++)
          if (isIndexInBounds(r - i + columnCount - 1, i))
            _values[r - i + columnCount - 1][i],
      ],
  ];
  Iterable<({int r, int c, T cell})> get cells =>
      indexes.map((i) => (r: i.r, c: i.c, cell: _values[i.r][i.c]));

  T call(int row, int column) => _values[row][column];

  void set(int row, int column, T value) => _values[row][column] = value;

  bool isIndexInBounds(int row, int column) =>
      row >= 0 && row < rowCount && column >= 0 && column < columnCount;

  @override
  List<Object?> get props => [_values];

  Iterable<({int r, int c})> get indexes sync* {
    for (var i = 0; i < _values.length; i++) {
      for (var j = 0; j < _values[i].length; j++) {
        yield (r: i, c: j);
      }
    }
  }

  Matrix<T> copy() => Matrix.fromList(_values.map((e) => e.toList()).toList());
}
