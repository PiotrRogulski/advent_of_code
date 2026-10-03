import 'dart:io';

import 'package:z3/z3.dart';

void setupZ3() {
  if (Platform.isMacOS) {
    libz3Override = .open('libz3.5.1.0.0.dylib');
  }
}
