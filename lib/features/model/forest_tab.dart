import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rattle/constants/app.dart';
import 'package:rattle/provider/stdout.dart';
import 'package:rattle/r/extract_forest.dart';

class ForestTab extends ConsumerWidget {
  const ForestTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String stdout = ref.watch(stdoutProvider);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 10),
      child: SingleChildScrollView(
        child: SelectableText(
          rExtractForest(stdout),
          style: monoTextStyle,
        ),
      ),
    );
  }
}
