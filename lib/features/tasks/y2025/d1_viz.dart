import 'dart:async';
import 'dart:math';

import 'package:advent_of_code/common/extensions/context.dart';
import 'package:advent_of_code/common/hooks/use_unbounded_animation_controller.dart';
import 'package:advent_of_code/common/widgets/visualization_stat.dart';
import 'package:advent_of_code/design_system/border.dart';
import 'package:advent_of_code/design_system/padding.dart';
import 'package:advent_of_code/design_system/unit.dart';
import 'package:advent_of_code/design_system/widgets/text.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:more/collection.dart';

typedef _I = ListInput<String>;

class Y2025D1Visualizer extends DayVisualizer<_I> {
  const Y2025D1Visualizer()
    : super(2025, 1, commonVisualizer: const .new(_part1and2));
}

Widget _part1and2(_I input) => HookBuilder(
  builder: (context) {
    final itemIndex = useState(0);

    final tapeController = useDisposable(
      builder: FixedExtentScrollController.new,
      dispose: (controller) => controller.dispose(),
    );

    final dialController = useUnboundedAnimationController(initialValue: 50);

    final timesStoppedAtZero = useState(0);
    final timesPassedZero = useState(0);

    useEffect(() {
      var canceled = false;

      () async {
        await Future<void>.delayed(const .new(milliseconds: 1000));

        while (true) {
          final current = input.values[itemIndex.value];
          final direction = current[0] == 'R' ? 1 : -1;
          final value = int.parse(current.substring(1));

          if (canceled) {
            return;
          }

          var lastValue = dialController.value % 100;
          void zeroPassListener() {
            final value = dialController.value % 100;

            // Starting from zero, will never could
            if (lastValue == 0) {
              lastValue = value;
              return;
            }

            // Stopped at zero, counts as passing zero
            if (value == 0 && !dialController.isAnimating) {
              timesPassedZero.value++;
              lastValue = value;
              return;
            }

            // Passed through actual zero
            if (lastValue.sign != value.sign &&
                lastValue.sign != 0 &&
                value.sign != 0) {
              timesPassedZero.value++;
              lastValue = value;
              return;
            }

            // Passed through zero modulo 100
            if ((lastValue - value).abs() > 50) {
              timesPassedZero.value++;
              lastValue = value;
              return;
            }

            lastValue = value;
          }

          dialController.addListener(zeroPassListener);
          await dialController.animateWith(
            SpringSimulation(
              .withDampingRatio(mass: 1, stiffness: 500),
              dialController.value,
              dialController.value + (direction * value),
              0,
              snapToEnd: true,
            ),
          );
          dialController.removeListener(zeroPassListener);

          if (dialController.value % 100 == 0) {
            timesStoppedAtZero.value++;
          }

          if (canceled) {
            return;
          }

          if (itemIndex.value < input.values.length - 1) {
            itemIndex.value++;
          } else {
            break;
          }

          await tapeController.animateToItem(
            itemIndex.value,
            duration: Durations.long1,
            curve: Curves.easeInOutCubicEmphasized,
          );
        }
      }();

      return () => canceled = true;
    }, []);

    return Row(
      children: [
        _TapeView(
          input: input,
          itemIndex: itemIndex.value,
          controller: tapeController,
        ),
        Expanded(
          child: Column(
            children: [
              Expanded(child: _DialView(controller: dialController)),
              _Stats(
                timesStoppedAtZero: timesStoppedAtZero.value,
                timesPassedZero: timesPassedZero.value,
              ),
            ],
          ),
        ),
      ],
    );
  },
);

const _tapeItemSize = 100.0;
const _currentBorderGap = AocUnit.medium;

class _TapeView extends StatelessWidget {
  const _TapeView({
    required this.input,
    required this.itemIndex,
    required this.controller,
  });

  final _I input;
  final int itemIndex;
  final FixedExtentScrollController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AocPadding(
      padding: .symmetric(horizontal: AocUnit.xlarge * 2),
      child: Stack(
        clipBehavior: .none,
        children: [
          SizedBox(
            width: _tapeItemSize,
            child: ListWheelScrollView.useDelegate(
              itemExtent: _tapeItemSize,
              controller: controller,
              renderChildrenOutsideViewport: true,
              clipBehavior: .none,
              perspective: 0.001,
              diameterRatio: 1.75,
              physics: const NeverScrollableScrollPhysics(),
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: input.values.length,
                builder: (context, index) =>
                    _TapeItem(input.values[index], current: index == itemIndex),
              ),
            ),
          ),
          Positioned(
            left: -_currentBorderGap,
            right: -_currentBorderGap,
            top: -_currentBorderGap,
            bottom: -_currentBorderGap,
            child: Center(
              child: Container(
                width: _tapeItemSize + _currentBorderGap,
                height: _tapeItemSize + _currentBorderGap,
                decoration: ShapeDecoration(
                  shape: AocBorder(
                    .large,
                    side: .new(
                      color: theme.colorScheme.primary,
                      width: AocUnit.small,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    ),
                  ),
                  shadows: [
                    .new(
                      color: theme.colorScheme.primary,
                      blurStyle: .outer,
                      blurRadius: AocUnit.large,
                    ),
                    .new(
                      color: theme.colorScheme.primary,
                      blurStyle: .outer,
                      blurRadius: AocUnit.large,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TapeItem extends StatelessWidget {
  const _TapeItem(this.item, {required this.current});

  final String item;
  final bool current;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox.square(
      dimension: _tapeItemSize,
      child: Container(
        decoration: ShapeDecoration(
          shape: AocBorder(.medium),
          color: theme.colorScheme.primaryContainer,
        ),
        child: Center(
          child: AocText(
            item,
            weight: current ? .bold : .light,
            style: theme.textTheme.headlineLarge!.apply(
              color: current ? theme.colorScheme.primary : null,
            ),
          ),
        ),
      ),
    );
  }
}

class _DialView extends HookWidget {
  const _DialView({required this.controller});

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final currentValue = useAnimation(controller);

    return SizedBox.expand(
      child: Stack(
        fit: .expand,
        children: [
          CustomPaint(
            painter: _DialPainter(
              colorScheme: theme.colorScheme,
              rotationRadians: 2 * pi * currentValue / 100,
            ),
          ),
          Center(
            child: AocText(
              currentValue.toStringAsFixed(0),
              style: theme.textTheme.headlineLarge,
            ),
          ),
        ],
      ),
    );
  }
}

class _DialPainter extends CustomPainter {
  const _DialPainter({
    required this.colorScheme,
    required this.rotationRadians,
  });

  final ColorScheme colorScheme;
  final double rotationRadians;

  @override
  void paint(Canvas canvas, Size size) {
    final dialSize = size.shortestSide * 2 / 3;

    final triangleSize = dialSize * 0.1;
    final trianglePath = Path()
      ..moveTo(
        size.width / 2 - triangleSize / 2,
        size.height / 2 - dialSize / 2 - triangleSize,
      )
      ..relativeLineTo(triangleSize, 0)
      ..relativeLineTo(-triangleSize / 2, triangleSize)
      ..close();
    canvas
      ..drawPath(
        trianglePath,
        .new()
          ..color = colorScheme.primary
          ..style = .fill,
      )
      ..save()
      ..clipPath(
        .new()..addOval(
          .fromCircle(
            center: .new(size.width / 2, size.height / 2),
            radius: dialSize / 2,
          ),
        ),
      )
      ..translate(size.width / 2, size.height / 2)
      ..rotate(rotationRadians)
      ..translate(-size.width / 2, -size.height / 2)
      ..drawPaint(.new()..color = colorScheme.primaryContainer);

    for (final i in 0.to(100)) {
      final angle = 2 * pi * i / 100 - pi / 2;
      final isMajor = i % 10 == 0;
      final isZero = i == 0;
      final tickLength = isZero
          ? dialSize * 0.2
          : (isMajor ? dialSize * 0.15 : dialSize * 0.1);

      final startX = size.width / 2 + cos(angle) * (dialSize / 2);
      final startY = size.height / 2 + sin(angle) * (dialSize / 2);
      final endX = size.width / 2 + cos(angle) * (dialSize / 2 - tickLength);
      final endY = size.height / 2 + sin(angle) * (dialSize / 2 - tickLength);

      final paint = Paint()
        ..color = isZero
            ? colorScheme.primary
            : colorScheme.onPrimaryContainer.withValues(
                alpha: isMajor ? 1 : 0.5,
              )
        ..strokeWidth = isZero ? 8 : (isMajor ? 2 : 1)
        ..strokeCap = .round
        ..style = .stroke;

      canvas.drawLine(.new(startX, startY), .new(endX, endY), paint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_DialPainter oldDelegate) =>
      colorScheme != oldDelegate.colorScheme ||
      rotationRadians != oldDelegate.rotationRadians;
}

class _Stats extends StatelessWidget {
  const _Stats({
    required this.timesStoppedAtZero,
    required this.timesPassedZero,
  });

  final int timesStoppedAtZero;
  final int timesPassedZero;

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;

    return AocPadding(
      padding: const .only(bottom: .large),
      child: Row(
        spacing: AocUnit.xsmall,
        mainAxisAlignment: .center,
        children: [
          VisualizationStat.first(
            value: timesStoppedAtZero,
            label: s.visualizer_2025_01_timesStoppedAtZero,
          ),
          VisualizationStat.last(
            value: timesPassedZero,
            label: s.visualizer_2025_01_timesPassedZero,
          ),
        ],
      ),
    );
  }
}
