import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AocScaffold extends HookWidget {
  const AocScaffold({
    super.key,
    required this.title,
    this.bodySlivers = const [],
  });

  final String title;
  final List<Widget> bodySlivers;

  static const _expandedHeight = 152.0;
  static const _collapsedHeight = 64.0;

  @override
  Widget build(BuildContext context) {
    final titleScale = useState<double>(1);

    // ignore: use_design_system_item_AocScaffold
    return Scaffold(
      body: NotificationListener(
        onNotification: (notification) {
          if (notification case ScrollNotification(:final metrics)) {
            final newValue =
                (metrics.pixels / (_expandedHeight - _collapsedHeight))
                    .clamp(0, 1)
                    .toDouble();
            titleScale.value = 1 - Curves.easeInOut.transform(newValue) / 2;
          }
          return false;
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar.large(
              flexibleSpace: SafeArea(
                child: Center(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.displayLarge?.apply(
                          fontSizeFactor: titleScale.value,
                        ),
                  ),
                ),
              ),
            ),
            ...bodySlivers,
          ],
        ),
      ),
    );
  }
}
