import 'package:more/more.dart' as more;

extension GenericX<T> on T {
  @Deprecated('Remove after debugging')
  T spy([dynamic Function(T)? selector]) {
    selector ??= (it) => it;
    // ignore: avoid_print
    print('>>> ${selector(this)}');
    return this;
  }

  Iterable<T> iterate(T Function(T value) f) => more.iterate(this, f);
}

extension GenericNonnullX<T extends Object> on T {
  U apply<U>(U Function(T) f) => f(this);
}
