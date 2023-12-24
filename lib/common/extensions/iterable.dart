import 'package:more/collection.dart';

extension IterableX<T> on Iterable<T> {
  Iterable<Iterable<T>> windowed(int windowSize) sync* {
    for (var i = 0; i < length - windowSize + 1; i++) {
      yield skip(i).take(windowSize);
    }
  }

  Iterable<Iterable<T>> chunked(int chunkSize) sync* {
    for (var i = 0; i < length; i += chunkSize) {
      yield skip(i).take(chunkSize);
    }
  }

  Iterable<T> takeUntil(bool Function(T) predicate) sync* {
    for (final element in this) {
      yield element;
      if (predicate(element)) {
        break;
      }
    }
  }

  Iterable<T> intersperse(T sep) sync* {
    if (isEmpty) {
      return;
    }

    yield* expand((e) => [sep, e]).skip(1);
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
