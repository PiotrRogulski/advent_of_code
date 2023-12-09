extension GenericX<T> on T {
  @Deprecated('Remove after debugging')
  T spy([dynamic Function(T)? selector]) {
    selector ??= (it) => it;
    // ignore: avoid_print
    print('>>> ${selector(this)}');
    return this;
  }

  Iterable<T> iterate(T Function(T value) f) sync* {
    var value = this;
    while (true) {
      yield value;
      value = f(value);
    }
  }
}

extension GenericNonnullX<T extends Object> on T {
  U apply<U>(U Function(T) f) => f(this);
}
