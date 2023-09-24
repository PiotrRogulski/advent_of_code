sealed class PartOutput {
  const PartOutput();
}

class StringOutput extends PartOutput {
  const StringOutput(this.value);

  final String value;
}

class NumericOutput extends PartOutput {
  const NumericOutput(this.value);

  final num value;
}
