import 'package:collection/collection.dart';

extension IterableIterableX<T> on Iterable<Iterable<T>> {
  Iterable<Iterable<T>> zip() sync* {
    final effectiveLength = map((iter) => iter.length).min;

    for (var i = 0; i < effectiveLength; i++) {
      yield map((iter) => iter.elementAt(i));
    }
  }
}
