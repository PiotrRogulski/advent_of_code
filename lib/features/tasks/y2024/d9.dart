import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

typedef _I = RawStringInput;
typedef _O = NumericOutput<int>;

class Y2024D9 extends DayData<_I> {
  const Y2024D9() : super(2024, 9, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) => RawStringInput(rawData);
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) => NumericOutput(
    inputData.value
        .split('')
        .map(int.parse)
        .expandIndexed(
          (index, length) =>
              index.isEven
                  ? List.filled(length, index ~/ 2)
                  : List.filled(length, null),
        )
        .toList()
        .iterate((l) {
          final firstNullIndex = l.indexOf(null);
          final lastValueIndex = l.lastIndexWhere((e) => e != null);
          return l
            ..[firstNullIndex] = l[lastValueIndex]
            ..[lastValueIndex] = null;
        })
        .takeUntil((l) => l.indexOf(null) > l.lastIndexWhere((e) => e != null))
        .last
        .whereType<int>()
        .mapIndexed((index, id) => index * id)
        .sum,
  );
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) => NumericOutput(
    inputData.value
        .split('')
        .map(int.parse)
        .mapIndexed(
          (index, length) =>
              index.isEven ? File(index ~/ 2, length) : EmptySpace(length),
        )
        .toList()
        .apply((l) {
          for (final file in l.whereType<File>().toList().reversed) {
            final fileIndex = l.indexOf(file);
            final emptySpaceInfo = findEmptySpace(l, file);
            if (emptySpaceInfo case (
              :final index,
              :final emptySpace,
            ) when index < fileIndex) {
              l
                ..[fileIndex] = EmptySpace(file.length)
                ..replaceRange(index, index + 1, [
                  file,
                  if (file.length < emptySpace.length)
                    EmptySpace(emptySpace.length - file.length),
                ]);
            }
          }
          return l;
        })
        .expand(
          (e) => switch (e) {
            EmptySpace(:final length) => List.filled(length, 0),
            File(:final id, :final length) => List.filled(length, id),
          },
        )
        .mapIndexed((index, id) => index * id)
        .sum,
  );
}

({int index, EmptySpace emptySpace})? findEmptySpace(
  List<DiskEntity> diskMap,
  File file,
) {
  final index = diskMap.indexWhere(
    (e) => e is EmptySpace && e.length >= file.length,
  );
  return index == -1
      ? null
      : (index: index, emptySpace: diskMap[index] as EmptySpace);
}

sealed class DiskEntity with EquatableMixin {
  DiskEntity(this.length);

  final int length;
}

class EmptySpace extends DiskEntity {
  EmptySpace(super.length);

  @override
  List<Object?> get props => [length];
}

class File extends DiskEntity {
  File(this.id, super.length);

  final int id;

  @override
  List<Object?> get props => [id, length];
}
