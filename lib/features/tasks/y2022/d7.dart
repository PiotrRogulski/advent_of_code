import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';

typedef _I = ListInput<_Command>;
typedef _O = NumericOutput<int>;

class Y2022D7 extends DayData<_I> {
  const Y2022D7() : super(2022, 7, parts: const {1: _P1(), 2: _P2()});

  static final _lineDelimRegex = RegExp(r'\n(?=\$)');

  @override
  _I parseInput(String rawData) {
    return ListInput(
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
                    _ => _FileLsEntry(name, int.parse(size)),
                  };
                }).toList(),
              ),
              _ => throw UnimplementedError(),
            },
          )
          .toList(),
    );
  }
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    return NumericOutput(
      inputData.values
          .fold(
            _FsExplorer(_Directory.root()),
            (exp, cmd) => exp..executeCommand(cmd),
          )
          .allDirectories
          .map((e) => e.size)
          .where((s) => s <= 100_000)
          .sum,
    );
  }
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    return NumericOutput(
      inputData.values
          .fold(
            _FsExplorer(_Directory.root()),
            (exp, cmd) => exp..executeCommand(cmd),
          )
          .apply((exp) => (exp: exp, sizeToRemove: exp.root.size - 40_000_000))
          .apply(
            (t) => t.exp.allDirectories.where((d) => d.size >= t.sizeToRemove),
          )
          .sortedBy((e) => e.size)
          .first
          .size,
    );
  }
}

sealed class _Command {
  const _Command();
}

class _ChangeDirectory extends _Command {
  const _ChangeDirectory(this.path);

  final String path;

  @override
  String toString() {
    return 'cd $path';
  }
}

class _ListDirectory extends _Command {
  const _ListDirectory(this.files);

  final List<_FileListing> files;

  @override
  String toString() {
    return 'ls ${files.map((e) => e.toString()).join(', ')}';
  }
}

sealed class _FileListing {
  const _FileListing();
}

class _DirectoryLsEntry extends _FileListing {
  const _DirectoryLsEntry(this.name);

  final String name;

  @override
  String toString() {
    return 'dir $name';
  }
}

class _FileLsEntry extends _FileListing {
  const _FileLsEntry(this.name, this.size);

  final String name;
  final int size;

  @override
  String toString() {
    return '$size $name';
  }
}

sealed class _FsEntity {
  const _FsEntity(this.name);

  final String name;

  int get size;

  String toRichString() {
    return _toRichStringInternal(0);
  }

  @protected
  String _toRichStringInternal(int level);
}

class _Directory extends _FsEntity {
  _Directory(super.name, List<_FsEntity> children)
    : children = EqualitySet(EqualityBy((e) => e.name))..addAll(children);
  _Directory.root() : this('', []);

  final EqualitySet<_FsEntity> children;

  @override
  int get size => children.map((e) => e.size).sum;

  @override
  String _toRichStringInternal(int level) {
    final buffer =
        StringBuffer()
          ..write(' ' * 4 * level)
          ..writeln(name);
    for (final child in children) {
      buffer.write(child._toRichStringInternal(level + 1));
    }
    return buffer.toString();
  }

  @override
  String toString() {
    return '$_Directory($name, ${children.length} children)';
  }
}

class _File extends _FsEntity {
  const _File(super.name, this.size);

  @override
  final int size;

  @override
  String _toRichStringInternal(int level) {
    final buffer =
        StringBuffer()
          ..write(' ' * 4 * (level - 1))
          ..write('└── ')
          ..writeln('$size $name');
    return buffer.toString();
  }
}

class _FsExplorer {
  _FsExplorer(this.root);

  final _Directory root;
  late final List<_Directory> currentPath = [root];

  String get cwd => currentPath.map((e) => e.name).join('/');

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
