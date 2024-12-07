import 'package:advent_of_code/app.dart';
import 'package:advent_of_code/global_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    AocProviders(sharedPreferences: sharedPreferences, child: const AocApp()),
  );
}
