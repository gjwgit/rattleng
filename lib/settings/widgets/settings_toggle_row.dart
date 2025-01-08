import 'package:flutter/material.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';

class ToggleRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final String tooltipMessage;

  const ToggleRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.tooltipMessage,
  });

  @override
  Widget build(BuildContext context) {
    return MarkdownTooltip(
      message: tooltipMessage,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
