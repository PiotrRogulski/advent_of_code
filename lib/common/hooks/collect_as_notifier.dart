import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

ValueNotifier<T> useCollectAsNotifier<T>(T value) {
  final notifier = useValueNotifier(value);
  useValueChanged<T, void>(value, (_, __) {
    notifier.value = value;
  });

  return notifier;
}
