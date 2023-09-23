import 'package:advent_of_code/design_system/page.dart';
import 'package:flutter/material.dart';

class SettingsPage extends AocPage<void> {
  const SettingsPage() : super(child: const SettingsScreen());
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Container(),
    );
  }
}
