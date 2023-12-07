import 'package:collection/collection.dart';

extension IterableX<T> on Iterable<T> {
  static Iterable<T> generate<T>(int length, T Function(int) generator) sync* {
    for (var i = 0; i < length; i++) {
      yield generator(i);
    }
  }

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
}

extension IterableIterableX<T> on Iterable<Iterable<T>> {
  Iterable<Iterable<T>> zip() sync* {
    final effectiveLength = map((iter) => iter.length).min;

    for (var i = 0; i < effectiveLength; i++) {
      yield map((iter) => iter.elementAt(i));
    }
  }
}

extension NumIterableX<T extends num> on Iterable<T> {
  T get product => reduce((a, b) => a * b as T);
}

extension Zip2X<T1, T2> on (Iterable<T1>, Iterable<T2>) {
  Iterable<(T1, T2)> zip() sync* {
    final iter1 = $1.iterator;
    final iter2 = $2.iterator;

    while (iter1.moveNext() && iter2.moveNext()) {
      yield (iter1.current, iter2.current);
    }
  }
}
