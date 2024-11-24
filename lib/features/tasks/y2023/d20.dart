import 'dart:collection';

import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:more/collection.dart';
import 'package:more/math.dart';

typedef _Module = ({String name, _ModType type, List<String> destinations});
typedef _ModuleState = ({_Module module, Map<String, bool> storage});
typedef _ModuleMessage = ({String destination, bool high, String sender});

typedef _I = ListInput<_Module>;
typedef _O = NumericOutput<int>;

class Y2023D20 extends DayData<_I> {
  const Y2023D20() : super(2023, 20, parts: const {1: _P1(), 2: _P2()});

  static final _moduleRegex = RegExp(
    r'^(broadcaster|%(?<flipFlop>\w+)|&(?<conj>\w+)) -> (?<dest>.+)$',
  );

  @override
  _I parseInput(String rawData) {
    return _I(
      rawData
          .split('\n')
          .map(_moduleRegex.firstMatch)
          .nonNulls
          .map(
            (m) => (
              name:
                  m.namedGroup('flipFlop') ??
                  m.namedGroup('conj') ??
                  m.group(1)!,
              type: switch ((m.namedGroup('flipFlop'), m.namedGroup('conj'))) {
                (!= null, _) => _ModType.flipFlop,
                (_, != null) => _ModType.conjunction,
                _ => _ModType.broadcaster,
              },
              destinations: m.namedGroup('dest')!.split(', '),
            ),
          )
          .toList(),
    );
  }
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    final states = Map.fromEntries(
      inputData.values.map(
        (m) => MapEntry(m.name, (
          module: m,
          storage: {
            if (m.type == _ModType.conjunction)
              for (final inputM in inputData.values)
                if (inputM.destinations.contains(m.name) &&
                    inputM.name != m.name)
                  inputM.name: false,
          },
        )),
      ),
    );
    var lows = 0;
    var highs = 0;
    for (final _ in 0.to(1000)) {
      final (:lowCount, :highCount) = _pushButton(states);
      lows += lowCount;
      highs += highCount;
    }
    return _O(lows * highs);
  }
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    final states = Map.fromEntries(
      inputData.values.map(
        (m) => MapEntry(m.name, (
          module: m,
          storage: {
            if (m.type == _ModType.conjunction)
              for (final inputM in inputData.values)
                if (inputM.destinations.contains(m.name) &&
                    inputM.name != m.name)
                  inputM.name: false,
          },
        )),
      ),
    );
    final outlet = inputData.values
        .expand((e) => e.destinations)
        .singleWhere((d) => !inputData.values.map((e) => e.name).contains(d));
    final outletInput = inputData.values.singleWhere(
      (m) => m.destinations.contains(outlet),
    );
    final outletInputs = inputData.values.where(
      (m) => m.destinations.contains(outletInput.name),
    );
    final d = _waitForOutletInputs(states, outletInputs);
    return _O(d.values.lcm());
  }
}

enum _ModType {
  broadcaster,
  flipFlop,
  conjunction;

  @override
  String toString() => name;
}

({int lowCount, int highCount}) _pushButton(Map<String, _ModuleState> states) {
  final pendingMessages =
      Queue<_ModuleMessage>()
        ..add((destination: 'broadcaster', high: false, sender: 'button'));

  var lowCount = 0;
  var highCount = 0;

  while (pendingMessages.isNotEmpty) {
    final message = pendingMessages.removeFirst();
    lowCount += message.high ? 0 : 1;
    highCount += message.high ? 1 : 0;
    final state = states[message.destination];
    if (state == null) {
      continue;
    }
    final newMessages = _invokeModule(
      state,
      high: message.high,
      sender: message.sender,
    );
    pendingMessages.addAll(newMessages);
  }

  return (lowCount: lowCount, highCount: highCount);
}

Map<String, int> _waitForOutletInputs(
  Map<String, _ModuleState> states,
  Iterable<_Module> rxInputs,
) {
  final map = <String, int>{};
  final pendingMessages = Queue<_ModuleMessage>();

  var i = 1;

  while (map.length < rxInputs.length) {
    pendingMessages.add((
      destination: 'broadcaster',
      high: false,
      sender: 'button',
    ));

    while (pendingMessages.isNotEmpty) {
      final (:sender, :high, :destination) = pendingMessages.removeFirst();
      if (rxInputs.map((e) => e.name).contains(destination) && !high) {
        map[destination] = i;
      }
      final state = states[destination];
      if (state == null) {
        continue;
      }
      pendingMessages.addAll(_invokeModule(state, high: high, sender: sender));
    }

    i++;
  }

  return map;
}

List<_ModuleMessage> _invokeModule(
  _ModuleState state, {
  required String sender,
  required bool high,
}) {
  switch (state.module.type) {
    case _ModType.broadcaster:
      return [
        for (final destination in state.module.destinations)
          (destination: destination, high: high, sender: state.module.name),
      ];
    case _ModType.flipFlop:
      final isOn = state.storage['isOn'] ?? false;
      if (!high) {
        state.storage['isOn'] = !isOn;
        return [
          for (final destination in state.module.destinations)
            (destination: destination, high: !isOn, sender: state.module.name),
        ];
      } else {
        return [];
      }
    case _ModType.conjunction:
      state.storage[sender] = high;
      final allHigh = state.storage.values.every((e) => e);
      return [
        for (final destination in state.module.destinations)
          (destination: destination, high: !allHigh, sender: state.module.name),
      ];
  }
}
