import 'package:equatable/equatable.dart';

sealed class const PartOutput() with Equatable;

class const StringOutput(final String value) extends PartOutput {
  @override
  List<Object?> get props => [value];
}

class const NumericOutput<T extends num>(final T value) extends PartOutput {
  @override
  List<Object?> get props => [value];
}
