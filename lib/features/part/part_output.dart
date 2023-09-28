import 'package:equatable/equatable.dart';

sealed class PartOutput with EquatableMixin {
  const PartOutput();
}

class StringOutput extends PartOutput {
  const StringOutput(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

class NumericOutput<T extends num> extends PartOutput {
  const NumericOutput(this.value);

  final T value;

  @override
  List<Object?> get props => [value];
}
