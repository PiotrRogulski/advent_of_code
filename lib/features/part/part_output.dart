import 'package:equatable/equatable.dart';

sealed class PartOutput {
  const PartOutput();
}

@Equatable()
class StringOutput extends PartOutput {
  const StringOutput(this.value);

  final String value;
}

@Equatable()
class NumericOutput<T extends num> extends PartOutput {
  const NumericOutput(this.value);

  final T value;
}
