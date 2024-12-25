// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'part_status_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PartStatusStore on _PartStatusStore, Store {
  Computed<
    List<
      ({
        PartOutput? data,
        ({Object error, StackTrace stackTrace})? error,
        Duration runDuration,
      })
    >
  >?
  _$runsComputed;

  @override
  List<
    ({
      PartOutput? data,
      ({Object error, StackTrace stackTrace})? error,
      Duration runDuration,
    })
  >
  get runs =>
      (_$runsComputed ??= Computed<
            List<
              ({
                PartOutput? data,
                ({Object error, StackTrace stackTrace})? error,
                Duration runDuration,
              })
            >
          >(() => super.runs, name: '_PartStatusStore.runs'))
          .value;

  late final _$_runningAtom = Atom(
    name: '_PartStatusStore._running',
    context: context,
  );

  bool get running {
    _$_runningAtom.reportRead();
    return super._running;
  }

  @override
  bool get _running => running;

  @override
  set _running(bool value) {
    _$_runningAtom.reportWrite(value, super._running, () {
      super._running = value;
    });
  }

  late final _$runAsyncAction = AsyncAction(
    '_PartStatusStore.run',
    context: context,
  );

  @override
  Future<void> run(PartInput data) {
    return _$runAsyncAction.run(() => super.run(data));
  }

  @override
  String toString() {
    return '''
runs: ${runs}
    ''';
  }
}
