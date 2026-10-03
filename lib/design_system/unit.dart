import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';
import 'package:meta/meta.dart';

extension type const AocUnit._(double _value) implements double {
  /// A value of 0.0.
  static const zero = AocUnit._(0);

  /// A value of 4.0.
  static const xsmall = AocUnit._(4);

  /// A value of 8.0.
  static const small = AocUnit._(8);

  /// A value of 16.0.
  static const medium = AocUnit._(16);

  /// A value of 24.0.
  static const large = AocUnit._(24);

  /// A value of 32.0.
  static const xlarge = AocUnit._(32);

  Widget get gap => Gap(_value);

  Widget get sliverGap => SliverGap(_value);

  @redeclare
  AocUnit operator *(double factor) => ._(_value * factor);

  @redeclare
  AocUnit operator /(double divisor) => ._(_value / divisor);

  @redeclare
  AocUnit operator +(AocUnit other) => ._(_value + other._value);
}
