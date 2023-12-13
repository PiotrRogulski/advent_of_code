extension IntX on int {
  Iterable<int> to(int end, {int step = 1}) sync* {
    if (step == 0) {
      throw ArgumentError.value(step, 'step', 'Step cannot be 0');
    }
    if (step > 0) {
      for (var i = this; i < end; i += step) {
        yield i;
      }
    } else {
      for (var i = this; i > end; i += step) {
        yield i;
      }
    }
  }
}
