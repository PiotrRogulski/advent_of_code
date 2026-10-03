import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';

typedef _I = ListInput<_Command>;
typedef _O = NumericOutput<int>;

class const Y2022D7() extends DayData<_I> {
  this : super(2022, 7, parts: const {1: _P1(), 2: _P2()});

  static final _lineDelimRegex = RegExp(r'\n(?=\$)');

  @override
  _I parseInput(String rawData) => .new(
    rawData
        .split(_lineDelimRegex)
        .map((l) => l.substring(2))
        .map(
          (l) => switch (l.substring(0, 2)) {
            'cd' => _ChangeDirectory(l.substring(3)),
            'ls' => _ListDirectory(
              l.substring(3).split('\n').map((e) {
                final [size, name] = e.split(' ');
                return switch (size) {
                  'dir' => _DirectoryLsEntry(name),
                  _ => _FileLsEntry(name, .parse(size)),
                };
              }).toList(),
            ),
            _ => throw UnimplementedError(),
          },
        )
        .toList(),
  );
}

class const _P1() extends PartImplementation<_I, _O> {
  this : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(
    inputData.values
        .fold(_FsExplorer(.root()), (exp, cmd) => exp..executeCommand(cmd))
        .allDirectories
        .map((e) => e.size)
        .where((s) => s <= 100_000)
        .sum,
  );
}

class const _P2() extends PartImplementation<_I, _O> {
  this : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(
    inputData.values
        .fold(_FsExplorer(.root()), (exp, cmd) => exp..executeCommand(cmd))
        .apply((exp) => (exp: exp, sizeToRemove: exp.root.size - 40_000_000))
        .apply(
          (t) => t.exp.allDirectories.where((d) => d.size >= t.sizeToRemove),
        )
        .sortedBy((e) => e.size)
        .first
        .size,
  );
}

sealed class const _Command();

class const _ChangeDirectory(final String path) extends _Command {
  @override
  String toString() => 'cd $path';
}

class const _ListDirectory(final List<_FileListing> files) extends _Command {
  @override
  String toString() => 'ls ${files.map((e) => e.toString()).join(', ')}';
}

sealed class const _FileListing();

class const _DirectoryLsEntry(final String name) extends _FileListing {
  @override
  String toString() => 'dir $name';
}

class const _FileLsEntry(final String name, final int size)
    extends _FileListing {
  @override
  String toString() => '$size $name';
}

sealed class const _FsEntity(final String name) {
  int get size;
}

class _Directory(super.name, List<_FsEntity> children) extends _FsEntity {
  new root() : this('', []);

  final children = EqualitySet<_FsEntity>(EqualityBy((e) => e.name))
    ..addAll(children);

  @override
  int get size => children.map((e) => e.size).sum;

  @override
  String toString() => '$_Directory($name, ${children.length} children)';
}

class const _File(super.name, @override final int size) extends _FsEntity;

class _FsExplorer(final _Directory root) {
  late final List<_Directory> currentPath = [root];

  void executeCommand(_Command cmd) {
    switch (cmd) {
      case _ChangeDirectory(:final path):
        goToDir(path);
      case _ListDirectory(:final files):
        files.forEach(addFileEntry);
    }
  }

  void goToDir(String dir) {
    switch (dir) {
      case '/':
        currentPath.clear();
        currentPath.add(root);
      case '..':
        currentPath.removeLast();
      default:
        currentPath.add(
          currentPath.last.children.whereType<_Directory>().singleWhere(
            (e) => e.name == dir,
          ),
        );
    }
  }

  void addFileEntry(_FileListing entry) {
    currentPath.last.children.add(switch (entry) {
      _DirectoryLsEntry(:final name) => _Directory(name, []),
      _FileLsEntry(:final name, :final size) => _File(name, size),
    });
  }

  Iterable<_Directory> get allDirectories {
    Iterable<_Directory> expandDir(_Directory root) sync* {
      yield root;
      for (final child in root.children.whereType<_Directory>()) {
        yield* expandDir(child);
      }
    }

    return root.children.whereType<_Directory>().expand(expandDir);
  }
}
