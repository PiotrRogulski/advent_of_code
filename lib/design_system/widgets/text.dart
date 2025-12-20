import 'package:advent_of_code/common/hooks/use_spring.dart';
import 'package:advent_of_code/design_system/dynamic_weight.dart';
import 'package:advent_of_code/gen/fonts.gen.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

class AocText extends HookWidget {
  const AocText(
    this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.weight,
    this.maxLines,
    this.overflow,
    this.monospaced = false,
  });

  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;
  final AocDynamicWeight? weight;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool monospaced;

  @override
  Widget build(BuildContext context) {
    final weightValue = useValueSpring(
      (weight ?? DynamicWeight.maybeOf(context)?.weight)?.value ?? -1,
      ratio: 0.75,
    );

    final baseStyle = DefaultTextStyle.of(context).style.merge(style);
    final effectiveTextStyle = baseStyle.copyWith(
      fontWeight: .values.firstWhereOrNull((e) => e.value == weight?.value),
      fontVariations: [
        ...?baseStyle.fontVariations,
        if (weightValue > 0) .weight(weightValue),
      ],
    );

    // This is the definition
    // ignore: leancode_lint/use_design_system_item
    return Text(
      data,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: monospaced
          ? effectiveTextStyle.copyWith(
              fontFamily: FontFamily.jetBrainsMono,
              height: 1.3,
            )
          : effectiveTextStyle,
    );
  }
}
