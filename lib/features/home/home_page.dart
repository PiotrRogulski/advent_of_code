import 'package:advent_of_code/design_system/page.dart';
import 'package:flutter/material.dart';

class HomePage extends AocPage<void> {
  const HomePage() : super(child: const HomeScreen());
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Container(),
    );
  }
}
