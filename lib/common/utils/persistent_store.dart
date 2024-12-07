import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';

mixin PersistentStore<T extends Object> on Store {
  @protected
  void restore(T data);

  @protected
  T get data;

  void persist({required T? Function() read, required void Function(T) write}) {
    if (read() case final saved?) {
      runInAction(() => restore(saved));
    }
    reaction((_) => data, write);
  }
}
