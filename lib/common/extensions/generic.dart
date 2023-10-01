import 'dart:developer';

extension GenericX<T> on T {
  @Deprecated('Remove after debugging')
  T spy([dynamic Function(T)? selector]) {
    selector ??= (it) => it;
    log('>>> ${selector(this)}');
    return this;
  }
}

extension GenericNonnullX<T extends Object> on T {
  U apply<U>(U Function(T) f) => f(this);
}
