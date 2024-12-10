import 'package:more/collection.dart';

extension IterableX<T> on Iterable<T> {
  Iterable<T> takeUntil(bool Function(T) predicate) sync* {
    for (final element in this) {
      yield element;
      if (predicate(element)) {
        break;
      }
    }
  }

  Iterable<T> uniqueBy<K>(K Function(T) keyOf) => unique(
    equals: (e1, e2) => keyOf(e1) == keyOf(e2),
    hashCode: (e) => keyOf(e).hashCode,
  );
}

extension NumIterableX<T extends num> on Iterable<T> {
  T get product => reduce((a, b) => a * b as T);

  Iterable<T> get diff sync* {
    for (final (a, b) in (this, skip(1)).zip()) {
      yield b - a as T;
    }
  }
}
