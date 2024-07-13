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
}

extension NumIterableX<T extends num> on Iterable<T> {
  T get product => reduce((a, b) => a * b as T);

  Iterable<T> get diff sync* {
    for (final (a, b) in (this, skip(1)).zip()) {
      yield b - a as T;
    }
  }
}
