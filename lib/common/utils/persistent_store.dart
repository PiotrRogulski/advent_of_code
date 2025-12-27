import 'package:dispose_scope/dispose_scope.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

abstract class PersistentStore<T extends Object> {
  PersistentStore({required T? Function() read, required this.write}) {
    restore(read());
  }

  final void Function(T) write;

  void restore(T? data);

  T get data;

  @protected
  final scope = DisposeScope();

  @protected
  BehaviorSubject<U> makeSubject<U>(U initialValue) => .seeded(initialValue)
    ..listen((_) => write(data)).disposedBy(scope)
    ..disposedBy(scope);

  Future<void> dispose() => scope.dispose();
}
