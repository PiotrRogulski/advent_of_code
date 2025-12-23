import 'dart:async';
import 'dart:math';

import 'package:advent_of_code/features/settings/settings_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:more/collection.dart';
import 'package:provider/provider.dart';

class SnowOverlay extends StatelessObserverWidget {
  const SnowOverlay({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final settings = context.read<SettingsStore>();

    if (!settings.christmasSpirit) {
      return child;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return _SnowOverlay(availableSize: constraints.biggest, child: child);
      },
    );
  }
}

typedef _Snowflake = ({
  double x,
  double y,
  double size,
  double velocity,
  double rotation,
});

class _SnowOverlay extends HookWidget {
  const _SnowOverlay({required this.availableSize, required this.child});

  final Size availableSize;
  final Widget child;

  static const _spawnDelay = Duration(milliseconds: 200);

  static final _random = Random();

  @override
  Widget build(BuildContext context) {
    final snowflakes = useState(<_Snowflake>[]);
    final lastFrameTime = useRef(DateTime.now());
    final timeSinceLastSnowflake = useRef(Duration.zero);
    final availableSize = useRef(this.availableSize);

    useValueChanged(
      this.availableSize,
      (_, _) => availableSize.value = this.availableSize,
    );

    useEffect(() {
      final t = Timer.periodic(const .new(milliseconds: 5), (t) {
        final now = DateTime.now();
        final delta = now.difference(lastFrameTime.value);
        lastFrameTime.value = now;

        final newSnowflakes = <_Snowflake>[];
        for (final snowflake in snowflakes.value) {
          final newY =
              snowflake.y + snowflake.velocity * delta.inMilliseconds / 1000;
          if (newY > availableSize.value.height + snowflake.size) {
            continue;
          }
          newSnowflakes.add((
            x: snowflake.x,
            y: newY,
            size: snowflake.size,
            velocity: snowflake.velocity,
            rotation: snowflake.rotation,
          ));
        }

        timeSinceLastSnowflake.value += delta;
        if (timeSinceLastSnowflake.value >= _spawnDelay) {
          timeSinceLastSnowflake.value = .zero;

          final newX = _random.nextDouble() * availableSize.value.width;
          final newSize = _random.nextDouble() * 5 + 5;
          final newVelocity = _random.nextDouble() * 100 + 25;
          final newRotation = _random.nextDouble() * pi * 2;

          newSnowflakes.add((
            x: newX,
            y: -newSize,
            size: newSize,
            velocity: newVelocity,
            rotation: newRotation,
          ));
        }

        snowflakes.value = newSnowflakes;
      });
      return t.cancel;
    }, []);

    return CustomPaint(
      willChange: true,
      foregroundPainter: _SnowPainter(snowflakes: snowflakes.value),
      child: child,
    );
  }
}

class _SnowPainter extends CustomPainter {
  const _SnowPainter({required this.snowflakes});

  final List<_Snowflake> snowflakes;

  @override
  void paint(Canvas canvas, Size size) {
    for (final snowflake in snowflakes) {
      final center = Offset(snowflake.x, snowflake.y);

      final path = Path();
      for (final i in 0.to(6)) {
        final d = Offset.fromDirection(
          pi / 6 * i + snowflake.rotation,
          snowflake.size * (i.isEven ? 1 : 0.75),
        );
        path
          ..moveTo(center.dx - d.dx, center.dy - d.dy)
          ..relativeLineTo(d.dx * 2, d.dy * 2);
      }

      canvas
        ..drawShadow(
          .new()..addOval(
            .fromCircle(
              center: center.translate(0, -4),
              radius: snowflake.size,
            ),
          ),
          Colors.black,
          8,
          true,
        )
        ..drawPath(
          path,
          .new()
            ..color = Colors.white
            ..strokeWidth = 2
            ..strokeCap = .round
            ..style = .stroke,
        );
    }
  }

  @override
  bool shouldRepaint(_SnowPainter oldDelegate) => true;
}
