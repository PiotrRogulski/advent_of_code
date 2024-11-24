// Needed to use resolveIdentifier
// ignore_for_file: deprecated_member_use

import 'package:collection/collection.dart';
import 'package:macros/macros.dart';

macro class AocDay implements LibraryTypesMacro, LibraryDefinitionMacro {
  const AocDay(
    this.year,
    this.day, {
    this.part1Complete = false,
    this.part2Complete = false,
  });

  final int year;
  final int day;
  final bool part1Complete;
  final bool part2Complete;

  @override
  Future<void> buildTypesForLibrary(
    Library library,
    TypeBuilder builder,
  ) async {
    final dayData = await builder.resolveIdentifier(
      Uri.parse(
        'package:advent_of_code/features/years/models/advent_structure.dart',
      ),
      'DayData',
    );
    final partImplementation = await builder.resolveIdentifier(
      Uri.parse(
        'package:advent_of_code/features/part/part_implementation.dart',
      ),
      'PartImplementation',
    );

    builder
      ..declareType(
        '_P1',
        DeclarationCode.fromParts([
          'final class _P1 extends ',
          partImplementation,
          '<_I, _O> {\n',
          '  const _P1() : super(completed: $part1Complete);\n',
          '\n',
          '  @override\n',
          '  _O runInternal(_I inputData) => _part1(inputData);\n',
          '}\n',
        ]),
      )
      ..declareType(
        '_P2',
        DeclarationCode.fromParts([
          'final class _P2 extends ',
          partImplementation,
          '<_I, _O> {\n',
          '  const _P2() : super(completed: $part2Complete);\n',
          '\n',
          '  @override\n',
          '  _O runInternal(_I inputData) => _part2(inputData);\n',
          '}\n',
        ]),
      )
      ..declareType(
        'Y${year}D$day',
        DeclarationCode.fromParts([
          'final class Y${year}D$day extends ',
          dayData,
          '<_I> {\n',
          '  const Y${year}D$day() : super($year, $day, parts: const {1: _P1(), 2: _P2()});\n',
          '\n',
          '  @override\n',
          '  _I parseInput(String rawData) => _parseInput(rawData);\n',
          '}\n',
        ]),
      );
  }

  @override
  Future<void> buildDefinitionForLibrary(
    Library library,
    LibraryDefinitionBuilder builder,
  ) async {
    final types = await builder.typesOf(library);
    final typeAliases = types.whereType<TypeAliasDeclaration>();

    final inputAlias = typeAliases.firstWhereOrNull(
      (e) => e.identifier.name == '_I',
    );
    if (inputAlias == null) {
      builder.error(
        'Missing input type alias `_I`.',
      );
    }

    final outputAlias = typeAliases.firstWhereOrNull(
      (e) => e.identifier.name == '_O',
    );
    if (outputAlias == null) {
      builder.error(
        'Missing output type alias `_O`.',
      );
    }

    final declarations = await builder.topLevelDeclarationsOf(library);
    final functions = declarations.whereType<FunctionDeclaration>();

    final parseInput = functions.firstWhereOrNull(
      (e) => e.identifier.name == '_parseInput',
    );
    if (parseInput == null) {
      builder.error(
        'Missing parse input function.',
      );
    }

    final part1 = functions.firstWhereOrNull(
      (e) => e.identifier.name == '_part1',
    );
    if (part1 == null) {
      builder.error(
        'Missing part 1.',
      );
    }

    final part2 = functions.firstWhereOrNull(
      (e) => e.identifier.name == '_part2',
    );
    if (part2 == null) {
      builder.error(
        'Missing part 2.',
      );
    }
  }
}

extension on DefinitionBuilder {
  void error(
    String message, {
    DiagnosticTarget? target,
    bool enabled = true,
  }) {
    if (enabled) {
      report(
        Diagnostic(
          DiagnosticMessage(message, target: target),
          Severity.error,
        ),
      );
    }
  }
}
