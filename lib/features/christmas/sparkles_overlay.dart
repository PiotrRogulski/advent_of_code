import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:advent_of_code/features/settings/settings_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:more/collection.dart';
import 'package:provider/provider.dart';

class SparklesOverlay extends StatelessObserverWidget {
  const SparklesOverlay({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final settings = context.read<SettingsStore>();

    if (!settings.christmasSpirit) {
      return child;
    }
    return _SparklesOverlay(child: child);
  }
}

typedef _Sparkle = ({Duration age, double x, double y, double size, int seed});

extension on _Sparkle {
  double get progress =>
      age.inMicroseconds / _SparklesOverlay._sparkleLifespan.inMicroseconds;

  Offset get center => .new(x, y + 50 * pow(progress, 2).toDouble());
}

class _SparklesOverlay extends HookWidget {
  const _SparklesOverlay({required this.child});

  final Widget child;

  static const _sparkleLifespan = Duration(milliseconds: 500);
  static const _sparkleCountLimit = 100;

  static final _random = Random();

  @override
  Widget build(BuildContext context) {
    final sparkles = useState(<_Sparkle>[]);
    final lastFrameDuration = useRef(Duration.zero);
    final pointerPositionController = useDisposable(
      builder: StreamController<Offset>.new,
      dispose: (controller) => controller.close(),
    );

    final tickerProvider = useSingleTickerProvider();

    useEffect(() {
      final sub = pointerPositionController.stream.listen((offset) {
        sparkles.value.add((
          age: .zero,
          x: offset.dx,
          y: offset.dy,
          size: lerpDouble(8, 32, _random.nextDouble())!,
          seed: _random.nextInt(1 << 32),
        ));
      });
      final ticker = tickerProvider.createTicker((dt) {
        final delta = dt - lastFrameDuration.value;
        lastFrameDuration.value = dt;
        final newSparkles = <_Sparkle>[];
        for (final sparkle in sparkles.value) {
          final newAge = sparkle.age + delta;
          if (newAge >= _sparkleLifespan) {
            continue;
          }
          newSparkles.add((
            age: newAge,
            x: sparkle.x,
            y: sparkle.y,
            size: sparkle.size,
            seed: sparkle.seed,
          ));
        }
        sparkles.value = newSparkles.sublist(
          max(0, newSparkles.length - _sparkleCountLimit),
          newSparkles.length,
        );
      })..start();

      return () {
        sub.cancel();
        ticker.dispose();
      };
    }, []);

    return MouseRegion(
      onHover: (event) => pointerPositionController.add(event.position),
      child: Listener(
        onPointerMove: (event) => pointerPositionController.add(event.position),
        child: Stack(
          children: [
            child,
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _SparklesPainter(sparkles: sparkles.value),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SparklesPainter extends CustomPainter {
  const _SparklesPainter({required this.sparkles});

  final List<_Sparkle> sparkles;

  @override
  void paint(Canvas canvas, Size size) {
    for (final _Sparkle(:size, :progress, :center) in sparkles) {
      canvas.drawShadow(
        .new()..addOval(
          .fromCircle(center: center.translate(0, -24), radius: size),
        ),
        Colors.orange.withValues(alpha: 1 - progress),
        24,
        true,
      );
    }

    for (final _Sparkle(:size, :seed, :progress, :center) in sparkles) {
      final random = Random(seed);

      final armCount = 10 + random.nextInt(6);
      final path = Path();
      for (final i in 0.to(armCount)) {
        final angle = pi * 2 / armCount * i + random.nextDouble() * pi;
        final d = Offset.fromDirection(angle, size * random.nextDouble());
        path
          ..moveTo(center.dx, center.dy)
          ..relativeLineTo(d.dx, d.dy);
      }

      canvas.drawPath(
        path,
        .new()
          ..color = Colors.yellow.withValues(alpha: 1 - progress)
          ..style = .stroke
          ..strokeWidth = 4
          ..strokeCap = .round,
      );
    }
  }

  @override
  bool shouldRepaint(_SparklesPainter oldDelegate) => false;
}
