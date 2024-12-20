import 'package:flutter/foundation.dart';
import 'package:more/more.dart' as more;

extension GenericX<T> on T {
  @Deprecated('Remove after debugging')
  T spy([dynamic Function(T)? selector]) {
    selector ??= (it) => it;
    debugPrint('>>> ${selector(this)}');
    return this;
  }

  Iterable<T> iterate(T Function(T value) f) => more.iterate(this, f);
}

extension GenericNonnullX<T extends Object> on T {
  U apply<U>(U Function(T) f) => f(this);
}

extension Tuple2X<T> on (T, T) {
  (R, R) mapBoth<R>(R Function(T) f) => (f(this.$1), f(this.$2));
}
