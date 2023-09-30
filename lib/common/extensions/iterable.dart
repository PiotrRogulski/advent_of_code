import 'package:collection/collection.dart';

extension IterableX<T> on Iterable<T> {
  Iterable<Iterable<T>> windowed(int windowSize) sync* {
    for (var i = 0; i < length - windowSize + 1; i++) {
      yield skip(i).take(windowSize);
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
