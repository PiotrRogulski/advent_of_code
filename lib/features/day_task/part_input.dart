sealed class PartInput {
  const PartInput();
}

class RawStringInput extends PartInput {
  const RawStringInput(this.value);

  final String value;
}

class ListInput<T> extends PartInput {
  const ListInput(this.values);

  final List<T> values;
}
