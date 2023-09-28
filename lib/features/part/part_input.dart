import 'package:equatable/equatable.dart';

sealed class PartInput with EquatableMixin {
  const PartInput();
}

class RawStringInput extends PartInput {
  const RawStringInput(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

class ListInput<T> extends PartInput {
  const ListInput(this.values);

  final List<T> values;

  @override
  List<Object?> get props => [values];
}
