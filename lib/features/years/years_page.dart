import 'package:advent_of_code/design_system/page.dart';
import 'package:flutter/material.dart';

class YearsPage extends AocPage<void> {
  const YearsPage() : super(child: const YearsScreen());
}

class YearsScreen extends StatelessWidget {
  const YearsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Years'),
      ),
      body: Container(),
    );
  }
}
