import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';

class SettingNumberField extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;
  final String? tooltip;

  const SettingNumberField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: value.toString());

    return MarkdownTooltip(
      message: tooltip ?? '',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 4),
          SizedBox(
            width: 80,
            child: Focus(
              onFocusChange: (hasFocus) {
                if (!hasFocus) {
                  final input = controller.text;
                  if (input.isNotEmpty) {
                    final parsedValue = int.tryParse(input);
                    if (parsedValue != null) {
                      onChanged(parsedValue);
                    }
                  }
                }
              },
              child: TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: controller,
                onSubmitted: (input) {
                  if (input.isNotEmpty) {
                    final parsedValue = int.tryParse(input);
                    if (parsedValue != null) {
                      onChanged(parsedValue);
                    }
                  }
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
