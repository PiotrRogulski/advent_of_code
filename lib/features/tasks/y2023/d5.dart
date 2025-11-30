import 'dart:math';

import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:more/collection.dart';

typedef _Range = ({int start, int length});
typedef _MapRange = ({int destStart, int sourceStart, int length});
typedef _Maps = ({
  List<int> seeds,
  List<_MapRange> seedToSoil,
  List<_MapRange> soilToFertilizer,
  List<_MapRange> fertilizerToWater,
  List<_MapRange> waterToLight,
  List<_MapRange> lightToTemperature,
  List<_MapRange> temperatureToHumidity,
  List<_MapRange> humidityToLocation,
});

typedef _I = ObjectInput<_Maps>;
typedef _O = NumericOutput<int>;

class Y2023D5 extends DayData<_I> {
  const Y2023D5() : super(2023, 5, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) {
    return ObjectInput(
      rawData.split('\n\n').apply((parts) {
        final [seedsPart, ...mapParts] = parts;
        final seeds = seedsPart.substring(7).split(' ').map(int.parse).toList();
        final maps = mapParts.map(_parseMap).toList();
        return (
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
  }

  List<_MapRange> _parseMap(String mapPart) {
    return mapPart.split('\n').skip(1).map((l) {
      final [destStart, sourceStart, length] = l.split(' ');
      return (
        destStart: int.parse(destStart),
        sourceStart: int.parse(sourceStart),
        length: int.parse(length),
      );
    }).toList();
  }
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    return NumericOutput(
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
  }

  static int Function(int) _applyMap(List<_MapRange> map) {
    return (value) {
      for (final m in map) {
        if (value >= m.sourceStart && value < m.sourceStart + m.length) {
          return m.destStart + value - m.sourceStart;
        }
      }
      return value;
    };
  }
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

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

    return NumericOutput(
      maps
          .fold(
            inputData.value.seeds
                .chunked(2)
                .map((s) => (start: s.first, length: s.last)),
            (ranges, m) {
              final newRanges = <_Range>[];

              for (var (:start, length: rangeLen) in ranges) {
                final end = start + rangeLen;
                while (start < end) {
                  var foundMatch = false;
                  var bestDistance = end - start;

                  for (final (:destStart, :sourceStart, length: mapLen) in m) {
                    if (sourceStart <= start && start < sourceStart + mapLen) {
                      final offset = start - sourceStart;
                      final remainingLength = min(mapLen - offset, end - start);
                      newRanges.add((
                        start: destStart + offset,
                        length: remainingLength,
                      ));
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
                    newRanges.add((start: start, length: effectiveLen));
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
