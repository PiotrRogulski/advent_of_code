extension Tuple2IterableX<T1, T2> on Iterable<(T1, T2)> {
  Iterable<(U, T2)> mapFirst<U>(U Function(T1) f) {
    return map((t) => (f(t.$1), t.$2));
  }

  Iterable<(T1, U)> mapSecond<U>(U Function(T2) f) {
    return map((t) => (t.$1, f(t.$2)));
  }
}
