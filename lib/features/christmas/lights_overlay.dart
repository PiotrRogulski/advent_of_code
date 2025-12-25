import 'dart:math';

import 'package:advent_of_code/features/settings/settings_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:provider/provider.dart';

class _LightsProgram {
  const _LightsProgram(this.cycle, this.intensity);

  final Duration cycle;
  final double Function(int i, double cycleProgress) intensity;
}

class LightsOverlay extends StatelessObserverWidget {
  const LightsOverlay({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final settings = context.read<SettingsStore>();

    if (!settings.christmasSpirit) {
      return child;
    }

    return _LightsOverlay(child: child);
  }
}

class _LightsOverlay extends HookWidget {
  const _LightsOverlay({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final programIndex = useState(0);
    final program = _programs[programIndex.value];

    final controller = useAnimationController(
      duration: program.cycle,
      keys: [programIndex.value],
    );
    useEffect(() {
      controller.repeat();
      return null;
    }, [programIndex.value]);

    useEffect(() {
      final keyboard = HardwareKeyboard.instance;
      bool handler(KeyEvent event) {
        if (int.tryParse(event.character ?? '') case final index?
            when 1 <= index && index <= _programs.length) {
          programIndex.value = index - 1;
          return true;
        }

        return false;
      }

      keyboard.addHandler(handler);
      return () => keyboard.removeHandler(handler);
    }, []);

    return CustomPaint(
      foregroundPainter: _LightsPainter(
        program: program,
        controller: controller,
      ),
      child: child,
    );
  }
}

class _LightsPainter extends CustomPainter {
  const _LightsPainter({required this.program, required this.controller})
    : super(repaint: controller);

  final _LightsProgram program;
  final AnimationController controller;

  static const _cordColor = Color(0xFF53A553);
  static final _cordPaint = Paint()
    ..color = _cordColor
    ..strokeWidth = 4
    ..strokeCap = .round
    ..style = .stroke;
  static const _padding = 32.0;
  static const _arcSpan = 32.0;
  static const _arcRadius = 16.0;

  static const _lightColors = <Color>[
    .new(0xFF_FF_00_00),
    .new(0xFF_FF_FF_00),
    .new(0xFF_00_FF_00),
    .new(0xFF_00_33_FF),
    .new(0xFF_FF_00_FF),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final progress = controller.value;

    final borderRect = (Offset.zero & size).deflate(_padding);
    final width = borderRect.width;
    final height = borderRect.height;

    ({Path arc, int arcCount, double arcSpan}) makeCordPath({
      required double length,
    }) {
      final arcCount = (length / _arcSpan).ceil() | 1;
      final arcSpan = length / arcCount;
      final arc = Path()..moveTo(0, 0);
      for (var i = 0; i < arcCount; i++) {
        final gap = _arcRadius / 1.5 * (i.isOdd ? 1 : -1);
        arc.relativeCubicTo(arcSpan / 3, gap, 2 * arcSpan / 3, gap, arcSpan, 0);
      }
      return (arc: arc, arcCount: arcCount, arcSpan: arcSpan);
    }

    void drawCord({required double length}) {
      final arc = makeCordPath(length: length).arc;
      canvas
        ..translate(borderRect.topLeft.dx, borderRect.topLeft.dy)
        ..drawPath(arc, _cordPaint)
        ..translate(length + _padding, -_padding)
        ..rotate(pi / 2);
    }

    var drawnLights = 0;
    void drawLights({required double length}) {
      final (:arc, :arcCount, :arcSpan) = makeCordPath(length: length);

      final metric = arc.computeMetrics().first;
      final totalPathLength = metric.length;
      final lightCount = (arcCount * 11 / 7).round();

      for (var i = 0; i < lightCount; i++) {
        final globalI = i + drawnLights;
        final distance = totalPathLength * i / lightCount;
        final tangent = metric.getTangentForOffset(distance)!;
        final normal = Offset(-tangent.vector.dy, tangent.vector.dx);
        final double direction;
        if (tangent.vector.dy.abs() < 1e-3) {
          direction = tangent.position.dy > 0 ? 1 : -1;
        } else {
          direction = tangent.vector.dy > 0 ? -1 : 1;
        }

        final position = tangent.position + normal * direction * 8;

        final color = _lightColors[globalI % _lightColors.length];
        final intensity = program.intensity(globalI, progress);

        canvas
          ..drawCircle(
            position,
            8,
            .new()
              ..color = .alphaBlend(color.withValues(alpha: 0.3), Colors.black),
          )
          ..drawCircle(
            position,
            16,
            .new()..color = color.withValues(alpha: 0.25 * intensity),
          )
          ..drawCircle(
            position,
            12,
            .new()..color = color.withValues(alpha: 0.5 * intensity),
          )
          ..drawCircle(
            position,
            8,
            .new()..color = color.withValues(alpha: intensity),
          );
      }

      canvas
        ..translate(length, 0)
        ..rotate(pi / 2);

      drawnLights += lightCount;
    }

    drawCord(length: width); // top
    drawCord(length: height); // right
    drawCord(length: width); // bottom
    drawCord(length: height); // left

    canvas.translate(borderRect.topLeft.dx, borderRect.topLeft.dy);

    drawLights(length: width); // top
    drawLights(length: height); // right
    drawLights(length: width); // bottom
    drawLights(length: height); // left
  }

  @override
  bool shouldRepaint(_LightsPainter oldDelegate) => false;
}

final _programs = <_LightsProgram>[
  .new(const .new(seconds: 1), (_, _) => 1),
  .new(
    const .new(seconds: 4),
    (_, cycleProgress) => (cos(cycleProgress * 2 * pi) + 1) / 2,
  ),
  .new(const .new(seconds: 2), (i, cycleProgress) {
    final progress = cycleProgress - (i % 3) / 3;
    return switch (progress) {
      >= 0 && <= 2 / 3 || <= -1 / 3 => sin(6 * progress * 2 * pi) >= 0 ? 1 : 0,
      _ => 0,
    };
  }),
  .new(
    const .new(seconds: 4),
    (i, cycleProgress) =>
        max(0, cos((cycleProgress + (i.isOdd ? 0.5 : 0)) * 2 * pi)),
  ),
  .new(const .new(seconds: 4), (_, _) => 0),
];
