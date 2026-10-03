import 'dart:ui';

import 'package:advent_of_code/common/hooks/use_emphasize.dart';
import 'package:advent_of_code/common/utils/z3_setup.dart';
import 'package:advent_of_code/design_system/border.dart';
import 'package:advent_of_code/design_system/padding.dart';
import 'package:advent_of_code/design_system/unit.dart';
import 'package:advent_of_code/design_system/widgets/blur.dart';
import 'package:advent_of_code/design_system/widgets/icon.dart';
import 'package:advent_of_code/design_system/widgets/text.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:flutter/foundation.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:material_ui/material_ui.dart';
import 'package:more/more.dart' hide IndexedIterableExtension;
import 'package:z3/z3.dart';

class const _Machine({
  required final ({String diagram, int bits}) target,
  required final List<({List<int> ids, int mask})> buttons,
  required final List<int> joltageRequirements,
});
typedef _I = ListInput<_Machine>;

const y2025D10Visualizer = DayVisualizer<_I>(
  parts: {1: .new(_Part1.new), 2: .new(_Part2.new)},
);

class const _Part1(final _I input) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _MachineSwitcher(
      machines: input.values,
      builder: _MachineIndicatorLightSimulation.new,
    );
  }
}

class const _Part2(final _I input) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _MachineSwitcher(
      machines: input.values,
      builder: _MachineJoltageSimulation.new,
    );
  }
}

class const _MachineSwitcher({
  required final List<_Machine> machines,
  required final Widget Function({
    required int index,
    required _Machine machine,
    required VoidCallback goToNext,
  })
  builder,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final currentMachineIndex = useState(0);

    void goToNext() {
      if (currentMachineIndex.value < machines.length - 1) {
        currentMachineIndex.value++;
      }
    }

    return AnimatedSwitcher(
      duration: Durations.long1,
      switchInCurve: Curves.ease,
      switchOutCurve: Curves.ease.flipped,
      transitionBuilder: (child, animation) {
        final positionTween = animation.isForwardOrCompleted
            ? Tween<Offset>(begin: const .new(-0.1, 0), end: .zero)
            : Tween<Offset>(begin: const .new(0.1, 0), end: .zero);
        return SlideTransition(
          position: positionTween.animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: Center(
        key: ValueKey(currentMachineIndex.value),
        child: builder(
          index: currentMachineIndex.value,
          machine: machines[currentMachineIndex.value],
          goToNext: goToNext,
        ),
      ),
    );
  }
}

class const _MachineIndicatorLightSimulation({
  required final int index,
  required final _Machine machine,
  required final VoidCallback goToNext,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final targetButtons = useMemoized(
      () => machine.buttons.indexed
          .powerSet()
          .where(
            (b) =>
                b.fold(0, (acc, btn) => acc ^ btn.$2.mask) ==
                machine.target.bits,
          )
          .smallest(1, comparator: keyOf((e) => e.length))
          .first,
      [machine],
    );

    final pressedButtons = useState(<int>{});
    final activeLightsMask = useState(0);

    useEffect(() {
      var canceled = false;

      () async {
        if (index == 0) {
          await Future<void>.delayed(const .new(milliseconds: 300));
        }

        for (final (i, button) in targetButtons) {
          await Future<void>.delayed(const .new(milliseconds: 500));
          if (canceled) {
            return;
          }

          pressedButtons.value = {...pressedButtons.value, i};
          activeLightsMask.value ^= button.mask;
        }

        await Future<void>.delayed(const .new(milliseconds: 500));
        if (!canceled) {
          goToNext();
        }
      }();

      return () => canceled = true;
    }, []);

    return _MachineView(
      index: index,
      machine: machine,
      buttonBuilder: (i) =>
          _MachineButton(isPressed: pressedButtons.value.contains(i)),
      topRowBuilder: (i) =>
          _MachineLight(isActive: activeLightsMask.value & (1 << i) != 0),
      bottomRowBuilder: (i) =>
          _MachineLight.small(isActive: machine.target.diagram[i] == '#'),
    );
  }
}

class const _MachineView({
  required final int index,
  required final _Machine machine,
  required final Widget Function(int index) buttonBuilder,
  required final Widget Function(int index) topRowBuilder,
  required final Widget Function(int index) bottomRowBuilder,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: .none,
      child: AocPadding(
        padding: const .all(.xlarge),
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: .min,
            spacing: AocUnit.xlarge * 2,
            crossAxisAlignment: .start,
            children: [
              Row(
                mainAxisSize: .min,
                spacing: AocUnit.large,
                crossAxisAlignment: .start,
                children: [
                  Container(
                    width: AocUnit.xlarge * 3,
                    height: AocUnit.xlarge * 2,
                    decoration: ShapeDecoration(
                      color: theme.colorScheme.surface,
                      shape: AocBorder(.small),
                    ),
                    alignment: .center,
                    child: AocText(
                      '#${index + 1}',
                      style: theme.textTheme.headlineLarge,
                    ),
                  ),
                  Expanded(
                    child: Row(
                      spacing: AocUnit.medium,
                      mainAxisAlignment: .center,
                      children: [
                        for (final i in 0.to(machine.target.diagram.length))
                          Column(
                            spacing: AocUnit.medium,
                            children: [topRowBuilder(i), bottomRowBuilder(i)],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                spacing: AocUnit.medium,
                mainAxisAlignment: .center,
                children: [
                  for (final i in 0.to(machine.buttons.length))
                    buttonBuilder(i),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MachineLight extends StatelessWidget {
  const new({required this.isActive}) : size = AocUnit.xlarge * 2;

  const new small({required this.isActive}) : size = AocUnit.large;

  final bool isActive;
  final AocUnit size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final activeColor = theme.colorScheme.primary;
    final inactiveColor = theme.colorScheme.surfaceContainerLowest;

    return AnimatedContainer(
      width: size,
      height: size,
      duration: Durations.medium1,
      curve: Curves.ease,
      decoration: ShapeDecoration(
        gradient: isActive
            ? RadialGradient(
                colors: [activeColor, activeColor.withValues(alpha: 0.75)],
              )
            : RadialGradient(colors: [inactiveColor, inactiveColor]),
        shape: CircleBorder(
          side: isActive
              ? .new(color: activeColor, width: AocUnit.xsmall)
              : .none,
        ),
        shadows: [
          if (isActive)
            .new(
              color: activeColor,
              blurRadius: AocUnit.medium,
              blurStyle: .outer,
            ),
        ],
      ),
    );
  }
}

class const _MachineButton({required final bool isPressed})
    extends StatelessWidget {
  static final size = AocUnit.xlarge * 2;
  static const borderRadius = AocUnit.medium;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = theme.colorScheme.outline;

    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: ShapeDecoration(
            color: baseColor,
            shape: AocBorder(borderRadius),
          ),
        ),
        AnimatedSlide(
          duration: Durations.short4,
          curve: Curves.ease,
          offset: isPressed ? .zero : const .new(0, -0.25),
          child: AnimatedContainer(
            duration: Durations.short4,
            curve: Curves.ease,
            width: size,
            height: size,
            decoration: ShapeDecoration(
              color: isPressed
                  ? theme.colorScheme.inversePrimary
                  : theme.colorScheme.outlineVariant,
              shape: AocBorder(
                borderRadius,
                side: .new(
                  color: theme.colorScheme.secondary,
                  width: AocUnit.small,
                ),
              ),
            ),
            child: AocIcon(
              .powerRounded,
              size: .large,
              color: isPressed
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}

class const _MachineJoltageSimulation({
  required final int index,
  required final _Machine machine,
  required final VoidCallback goToNext,
}) extends HookWidget {
  static List<int> _calculateCounts(_Machine machine) {
    setupZ3();

    final opt = optimize();

    final btnVars = [
      for (final i in 0.to(machine.buttons.length)) constVar('btn$i', intSort),
    ];
    for (final btn in btnVars) {
      opt.add(btn >= 0);
    }

    for (final (i, req) in machine.joltageRequirements.indexed) {
      final linkedButtons = machine.buttons.indexed.where(
        (btn) => btn.$2.ids.contains(i),
      );
      opt.add(
        eq(
          addN([for (final (linked, _) in linkedButtons) btnVars[linked]]),
          intFrom(req),
        ),
      );
    }

    final total = constVar('total', intSort);
    opt
      ..add(total >= 0)
      ..add(eq(total, addN(btnVars)))
      ..minimize(total)
      ..check();

    return [for (final btn in btnVars) opt.getModel().eval(btn)!.toInt()];
  }

  @override
  Widget build(BuildContext context) {
    final targetCounts = useFuture(
      useMemoized(() => compute(_calculateCounts, machine), [machine]),
    ).data;

    final counts = useState(List.filled(machine.joltageRequirements.length, 0));
    final pressCounts = useState(List.filled(machine.buttons.length, 0));

    if (targetCounts == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // That's ok
    // ignore: aoc_lint/avoid_conditional_hooks
    useEffect(() {
      var canceled = false;

      () async {
        if (index == 0) {
          await Future<void>.delayed(const .new(milliseconds: 300));
        }

        for (final (i, button) in machine.buttons.indexed) {
          final count = targetCounts[i];
          if (count == 0) {
            continue;
          }

          for (final _ in 0.to(count)) {
            await Future<void>.delayed(const .new(milliseconds: 500));
            if (canceled) {
              return;
            }

            final newCounts = counts.value.toList();
            final newPressCounts = pressCounts.value.toList();
            for (final id in button.ids) {
              newCounts[id]++;
            }
            newPressCounts[i]++;
            counts.value = newCounts;
            pressCounts.value = newPressCounts;
          }
        }

        await Future<void>.delayed(const .new(milliseconds: 800));
        if (!canceled) {
          goToNext();
        }
      }();

      return () => canceled = true;
    }, []);

    return _MachineView(
      index: index,
      machine: machine,
      buttonBuilder: (i) =>
          _MachineCounterButton(pressedCount: pressCounts.value[i]),
      topRowBuilder: (i) => _MachineCounter(value: counts.value[i]),
      bottomRowBuilder: (i) =>
          _MachineCounter.small(value: machine.joltageRequirements[i]),
    );
  }
}

enum _CounterSize() {
  large,
  small,
}

class _MachineCounter extends HookWidget {
  const new({required this.value}) : variant = .large;

  const new small({required this.value}) : variant = .small;

  final int value;
  final _CounterSize variant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final (:size, :textStyle, :borderRadius, :borderWidth) = switch (variant) {
      .large => (
        size: AocUnit.xlarge * 2,
        textStyle: theme.textTheme.headlineLarge,
        borderRadius: AocUnit.medium,
        borderWidth: AocUnit.xsmall,
      ),
      .small => (
        size: AocUnit.xlarge,
        textStyle: theme.textTheme.titleMedium,
        borderRadius: AocUnit.small,
        borderWidth: AocUnit.xsmall / 2,
      ),
    };

    final emphasisProgress = useEmphasize(value);

    return Container(
      width: size,
      height: size,
      decoration: ShapeDecoration(
        shape: AocBorder(
          borderRadius,
          side: .new(
            color: theme.colorScheme.primary.withValues(
              alpha: lerpDouble(0.25, 1, emphasisProgress),
            ),
            width: borderWidth,
          ),
        ),
        shadows: [
          BoxShadow(
            blurRadius: AocUnit.medium * emphasisProgress,
            color: theme.colorScheme.primary.withValues(
              alpha: emphasisProgress,
            ),
            blurStyle: .outer,
          ),
        ],
      ),
      alignment: .center,
      child: BlurSwitcher(
        child: AocText(
          key: ValueKey(value),
          value.toString(),
          style: textStyle,
        ),
      ),
    );
  }
}

class const _MachineCounterButton({required final int pressedCount})
    extends HookWidget {
  static final size = AocUnit.xlarge * 2;
  static const borderRadius = AocUnit.medium;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = theme.colorScheme.outline;

    final emphasisProgress = useEmphasize(pressedCount);

    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: ShapeDecoration(
            color: baseColor,
            shape: AocBorder(borderRadius),
          ),
        ),
        Transform.translate(
          offset: .new(0, size * -0.25 * (1 - emphasisProgress)),
          child: Container(
            width: size,
            height: size,
            decoration: ShapeDecoration(
              color: .lerp(
                theme.colorScheme.outlineVariant,
                theme.colorScheme.inversePrimary,
                emphasisProgress,
              ),
              shape: AocBorder(
                borderRadius,
                side: .new(
                  color: theme.colorScheme.secondary,
                  width: AocUnit.small,
                ),
              ),
            ),
            child: AocIcon(
              .plusOne,
              size: .large,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
