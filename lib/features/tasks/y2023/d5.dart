import 'dart:math';

import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:more/collection.dart';

class const _Range({required final int start, required final int length});
class const _MapRange({
  required final int destStart,
  required final int sourceStart,
  required final int length,
});
class const _Maps({
  required final List<int> seeds,
  required final List<_MapRange> seedToSoil,
  required final List<_MapRange> soilToFertilizer,
  required final List<_MapRange> fertilizerToWater,
  required final List<_MapRange> waterToLight,
  required final List<_MapRange> lightToTemperature,
  required final List<_MapRange> temperatureToHumidity,
  required final List<_MapRange> humidityToLocation,
});

typedef _I = ObjectInput<_Maps>;
typedef _O = NumericOutput<int>;

class const Y2023D5() extends DayData<_I> {
  this : super(2023, 5, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) => .new(
    rawData.split('\n\n').apply((parts) {
      final [seedsPart, ...mapParts] = parts;
      final seeds = seedsPart.substring(7).split(' ').map(int.parse).toList();
      final maps = mapParts.map(_parseMap).toList();
      return .new(
        seeds: seeds,
        seedToSoil: maps[0],
        soilToFertilizer: maps[1],
        fertilizerToWater: maps[2],
        waterToLight: maps[3],
        lightToTemperature: maps[4],
        temperatureToHumidity: maps[5],
        humidityToLocation: maps[6],
      );
    }),
  );

  List<_MapRange> _parseMap(String mapPart) =>
      mapPart.split('\n').skip(1).map((l) {
        final [destStart, sourceStart, length] = l.split(' ');
        return _MapRange(
          destStart: .parse(destStart),
          sourceStart: .parse(sourceStart),
          length: .parse(length),
        );
      }).toList();
}

class const _P1() extends PartImplementation<_I, _O> {
  this : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(
    inputData.value.seeds
        .map(
          (s) => s
              .apply(_applyMap(inputData.value.seedToSoil))
              .apply(_applyMap(inputData.value.soilToFertilizer))
              .apply(_applyMap(inputData.value.fertilizerToWater))
              .apply(_applyMap(inputData.value.waterToLight))
              .apply(_applyMap(inputData.value.lightToTemperature))
              .apply(_applyMap(inputData.value.temperatureToHumidity))
              .apply(_applyMap(inputData.value.humidityToLocation)),
        )
        .min,
  );

  static int Function(int) _applyMap(List<_MapRange> map) => (value) {
    for (final m in map) {
      if (value >= m.sourceStart && value < m.sourceStart + m.length) {
        return m.destStart + value - m.sourceStart;
      }
    }
    return value;
  };
}

class const _P2() extends PartImplementation<_I, _O> {
  this : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    final maps = [
      inputData.value.seedToSoil,
      inputData.value.soilToFertilizer,
      inputData.value.fertilizerToWater,
      inputData.value.waterToLight,
      inputData.value.lightToTemperature,
      inputData.value.temperatureToHumidity,
      inputData.value.humidityToLocation,
    ];

    return .new(
      maps
          .fold(
            inputData.value.seeds
                .chunked(2)
                .map((s) => _Range(start: s.first, length: s.last)),
            (ranges, m) {
              final newRanges = <_Range>[];

              for (var _Range(:start, length: rangeLen) in ranges) {
                final end = start + rangeLen;
                while (start < end) {
                  var foundMatch = false;
                  var bestDistance = end - start;

                  for (final _MapRange(:destStart, :sourceStart, length: mapLen)
                      in m) {
                    if (sourceStart <= start && start < sourceStart + mapLen) {
                      final offset = start - sourceStart;
                      final remainingLength = min(mapLen - offset, end - start);
                      newRanges.add(
                        .new(
                          start: destStart + offset,
                          length: remainingLength,
                        ),
                      );
                      start += remainingLength;
                      foundMatch = true;
                      break;
                    } else {
                      if (start < sourceStart) {
                        bestDistance = min(bestDistance, sourceStart - start);
                      }
                    }
                  }

                  if (!foundMatch) {
                    final effectiveLen = min(bestDistance, end - start);
                    newRanges.add(.new(start: start, length: effectiveLen));
                    start += effectiveLen;
                  }
                }
              }

              return newRanges;
            },
          )
          .map((r) => r.start)
          .min,
    );
  }
}
