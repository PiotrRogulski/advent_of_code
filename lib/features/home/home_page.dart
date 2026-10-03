import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/design_system/page.dart';
import 'package:advent_of_code/design_system/widgets/scaffold.dart';
import 'package:material_ui/material_ui.dart';

class const HomePage() extends AocPage {
  this : super(child: const HomeScreen());
}

class const HomeScreen({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = context.l10n;

    return AocScaffold(title: s.home_title);
  }
}
