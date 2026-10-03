import 'package:advent_of_code/common/utils/matrix.dart';
import 'package:equatable/equatable.dart';

sealed class const PartInput() with Equatable;

class const RawStringInput(final String value) extends PartInput {
  @override
  List<Object?> get props => [value];
}

class const ListInput<T>(final List<T> values) extends PartInput {
  @override
  List<Object?> get props => [values];
}

class MatrixInput<T>(List<List<T>> values, {final bool dense = false})
    extends PartInput {
  final Matrix<T> matrix = .fromList(values);
  @override
  List<Object?> get props => [matrix, dense];
}

class const ObjectInput<T>(
  final T value, {
  final String Function(T)? stringifier,
}) extends PartInput {
  String toRichString() => stringifier?.call(value) ?? value.toString();

  @override
  List<Object?> get props => [value, stringifier];
}
