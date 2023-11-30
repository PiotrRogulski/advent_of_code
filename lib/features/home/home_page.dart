import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/design_system/page.dart';
import 'package:advent_of_code/design_system/widgets/scaffold.dart';
import 'package:flutter/material.dart';

class HomePage extends AocPage<void> {
  const HomePage() : super(child: const HomeScreen());
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;

    return AocScaffold(
      title: s.home_title,
    );
  }
}
