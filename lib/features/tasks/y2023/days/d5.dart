import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';

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
  const Y2023D5() : super(year: 2023, day: 5);

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

  @override
  Map<int, PartImplementation<_I, _O>> get parts => {
        1: const _P1(),
        2: const _P2(),
      };
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
  const _P2() : super(completed: false);

  @override
  _O runInternal(_I inputData) {
    throw UnimplementedError();
  }
}
