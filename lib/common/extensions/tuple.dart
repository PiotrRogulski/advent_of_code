extension Tuple2X<T1, T2> on (T1, T2) {
  (U, T2) mapFirst<U>(U Function(T1) f) => (f($1), $2);
  (T1, U) mapSecond<U>(U Function(T2) f) => ($1, f($2));
}
