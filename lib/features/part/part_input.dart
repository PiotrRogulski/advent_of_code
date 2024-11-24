import 'package:advent_of_code/common/utils/matrix.dart';
import 'package:equatable/equatable.dart';

sealed class PartInput {
  const PartInput();
}

@Equatable()
class RawStringInput extends PartInput {
  const RawStringInput(this.value);

  final String value;
}

@Equatable()
class ListInput<T> extends PartInput {
  const ListInput(this.values);

  final List<T> values;
}

@Equatable()
class MatrixInput<T> extends PartInput {
  const MatrixInput(this.matrix, {this.dense = false});

  final Matrix<T> matrix;
  final bool dense;
}

@Equatable()
class ObjectInput<T> extends PartInput {
  const ObjectInput(this.value, {this.stringifier});

  final T value;
  final String Function(T)? stringifier;

  String toRichString() => stringifier?.call(value) ?? value.toString();
}
