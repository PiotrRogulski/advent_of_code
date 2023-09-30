import 'dart:developer';

extension GenericX<T> on T {
  @Deprecated('Remove after debugging')
  T spy([String? label]) {
    log('>>> ${label == null ? '' : '$label: '}$this');
    return this;
  }
}

extension GenericNonnullX<T extends Object> on T {
  U apply<U>(U Function(T) f) => f(this);
}
