import 'package:flutter/cupertino.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

ValueNotifier<T> useCollectAsNotifier<T>(T value) {
  final notifier = useValueNotifier(value);
  useValueChanged<T, void>(value, (_, _) {
    notifier.value = value;
  });

  return notifier;
}
