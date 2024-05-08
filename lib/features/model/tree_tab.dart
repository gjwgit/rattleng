import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rattle/constants/app.dart';
import 'package:rattle/provider/stdout.dart';
import 'package:rattle/r/extract_tree.dart';

class TreeTab extends ConsumerWidget {
  const TreeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String stdout = ref.watch(stdoutProvider);
    return Expanded(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 10),
        child: SingleChildScrollView(
          child: SelectableText(
            rExtractTree(stdout),
            style: monoTextStyle,
          ),
        ),
      ),
    );
  }
}
