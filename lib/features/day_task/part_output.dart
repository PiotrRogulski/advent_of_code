sealed class PartOutput {
  const PartOutput();
}

class StringOutput extends PartOutput {
  const StringOutput(this.value);

  final String value;
}

class NumericOutput<T extends num> extends PartOutput {
  const NumericOutput(this.value);

  final T value;
}
