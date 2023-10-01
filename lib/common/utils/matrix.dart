import 'package:advent_of_code/common/extensions/iterable.dart';
import 'package:equatable/equatable.dart';

class Matrix<T> with EquatableMixin {
  Matrix.fromList(this._values)
      : assert(_values.map((e) => e.length).toSet().length == 1);

  final List<List<T>> _values;

  int get rowCount => _values.length;

  int get columnCount => _values.first.length;

  Iterable<Iterable<T>> get rows => _values;
  Iterable<Iterable<T>> get columns => _values.zip();

  T call(int row, int column) => _values[row][column];

  @override
  List<Object?> get props => [_values];

  Iterable<(int, int)> get indexes {
    return [
      for (var i = 0; i < _values.length; i++)
        for (var j = 0; j < _values[i].length; j++) (i, j),
    ];
  }
}
