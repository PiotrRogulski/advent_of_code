import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:rxdart/rxdart.dart';

T useValueStream<T>(ValueStream<T> stream) {
  final value = useState(stream.value);
  final didEmit = useRef(false);

  useOnStreamChange(
    stream,
    onData: (data) {
      if (!didEmit.value) {
        didEmit.value = true;
        return;
      }
      value.value = data;
    },
  );

  return value.value;
}
