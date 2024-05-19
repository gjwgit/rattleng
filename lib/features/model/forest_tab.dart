import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rattle/constants/app.dart';
import 'package:rattle/provider/stdout.dart';
import 'package:rattle/r/extract_forest.dart';
import 'package:rattle/utils/add_build_button.dart';

class ForestTab extends ConsumerWidget {
  final Widget buildButton;
  const ForestTab({super.key, required this.buildButton});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String stdout = ref.watch(stdoutProvider);
    Widget content = Expanded(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 10),
        child: SingleChildScrollView(
          child: SelectableText(
            rExtractForest(stdout),
            style: monoTextStyle,
          ),
        ),
      ),
    );
    return addBuildButton(content, buildButton);
  }
}
