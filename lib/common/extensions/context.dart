import 'package:advent_of_code/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

extension BuildContextX on BuildContext {
  AppLocalizations get l10n => .of(this);
}
