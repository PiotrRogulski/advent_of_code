import 'package:advent_of_code/features/christmas/snow_overlay.dart';
import 'package:advent_of_code/features/christmas/sparkles_overlay.dart';
import 'package:flutter/material.dart';

class ChristmasOverlay extends StatelessWidget {
  const ChristmasOverlay({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SparklesOverlay(child: SnowOverlay(child: child));
  }
}
