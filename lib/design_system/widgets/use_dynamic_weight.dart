import 'package:advent_of_code/design_system/dynamic_weight.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

({
  AocDynamicWeight weight,
  double fill,
  WidgetStatesController controller,
}) useDynamicWeight() {
  final iconWeight = useState(AocDynamicWeight.light);
  final fill = useState<double>(0);

  final statesController = useMaterialStatesController();
  useEffect(
    () {
      void listener() {
        if (statesController.value.contains(WidgetState.pressed)) {
          iconWeight.value = AocDynamicWeight.bold;
          fill.value = 1;
        } else if (statesController.value.contains(WidgetState.hovered)) {
          iconWeight.value = AocDynamicWeight.regular;
          fill.value = 1;
        } else {
          iconWeight.value = AocDynamicWeight.light;
          fill.value = 0;
        }
      }

      statesController.addListener(listener);
      return () => statesController.removeListener(listener);
    },
    [],
  );

  return (
    weight: iconWeight.value,
    fill: fill.value,
    controller: statesController,
  );
}
