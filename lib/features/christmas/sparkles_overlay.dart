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

class _SparklesOverlay extends HookWidget {
  const _SparklesOverlay({required this.child});

  final Widget child;

  static const _sparkleLifespan = Duration(milliseconds: 500);
  static const _sparkleCountLimit = 100;

  static final _random = Random();

  @override
  Widget build(BuildContext context) {
    final sparkles = useState(<_Sparkle>[]);
    final lastFrameTime = useRef(DateTime.now());
    final pointerPositionController = useDisposable(
      builder: StreamController<Offset>.new,
      dispose: (controller) => controller.close(),
    );

    useEffect(() {
      final sub = pointerPositionController.stream.listen((offset) {
        sparkles.value.add((
          age: .zero,
          x: offset.dx,
          y: offset.dy,
          size: lerpDouble(4, 16, _random.nextDouble())!,
          seed: _random.nextInt(1 << 32),
        ));
      });

      final t = Timer.periodic(const .new(milliseconds: 5), (t) {
        final now = DateTime.now();
        final delta = now.difference(lastFrameTime.value);
        lastFrameTime.value = now;
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
      });
      return () {
        sub.cancel();
        t.cancel();
      };
    }, []);

    return MouseRegion(
      onHover: (details) {
        pointerPositionController.add(details.position);
      },
      child: Listener(
        onPointerMove: (details) {
          pointerPositionController.add(details.position);
        },
        child: Stack(
          children: [
            child,
            for (final sparkle in sparkles.value)
              Positioned.fromRect(
                rect: .fromCircle(
                  center: .new(sparkle.x, sparkle.y),
                  radius: sparkle.size,
                ),
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _SparklePainter(seed: sparkle.seed),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SparklePainter extends CustomPainter {
  const _SparklePainter({required this.seed});

  final int seed;

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(seed);

    final center = size.center(.zero);
    final armCount = 10 + random.nextInt(6);
    final path = Path();
    for (final i in 0.to(armCount)) {
      final angle = pi * 2 / armCount * i + random.nextDouble() * pi;
      final d = Offset.fromDirection(
        angle,
        size.shortestSide * random.nextDouble(),
      );
      path
        ..moveTo(center.dx, center.dy)
        ..relativeLineTo(d.dx, d.dy);
    }

    canvas
      ..drawShadow(
        .new()..addOval(
          .fromCircle(
            center: center.translate(0, -24),
            radius: size.shortestSide,
          ),
        ),
        Colors.orange,
        24,
        true,
      )
      ..drawPath(
        path,
        .new()
          ..color = Colors.yellow
          ..style = .stroke
          ..strokeWidth = 4
          ..strokeCap = .round,
      );
  }

  @override
  bool shouldRepaint(_SparklePainter oldDelegate) => seed != oldDelegate.seed;
}
