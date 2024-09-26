import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Custom LabelledCheckbox widget
class LabelledCheckbox extends ConsumerWidget {
  final String label;
  final String tooltip;
  final StateProvider<bool> provider;

  const LabelledCheckbox({
    required this.label,
    required this.tooltip,
    required this.provider,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isChecked =
        ref.watch(provider); // Watch the provider for changes

    return Tooltip(
      message: tooltip,
      child: Row(
        children: [
          Checkbox(
            value: isChecked,
            onChanged: (value) {
              ref.read(provider.notifier).state =
                  value ?? false; // Update the provider's value
            },
          ),
          GestureDetector(
            onTap: () {
              // Toggle checkbox when the label is tapped
              ref.read(provider.notifier).state = !isChecked;
            },
            child: Text(label),
          ),
        ],
      ),
    );
  }
}
