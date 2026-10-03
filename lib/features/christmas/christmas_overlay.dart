import 'package:advent_of_code/features/christmas/lights_overlay.dart';
import 'package:advent_of_code/features/christmas/snow_overlay.dart';
import 'package:advent_of_code/features/christmas/sparkles_overlay.dart';
import 'package:material_ui/material_ui.dart';

class const ChristmasOverlay({super.key, required final Widget child})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SparklesOverlay(
      child: LightsOverlay(child: SnowOverlay(child: child)),
    );
  }
}
