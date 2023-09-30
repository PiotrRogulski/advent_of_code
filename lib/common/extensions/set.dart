extension SetX<T> on Set<T> {
  Set<T> operator &(Set<T> other) => intersection(other);
}
