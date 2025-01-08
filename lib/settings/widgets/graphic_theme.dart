import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';
import 'package:rattle/constants/settings.dart';
import 'package:rattle/constants/spacing.dart';
import 'package:rattle/providers/settings.dart';
import 'package:rattle/r/source.dart';

class GraphicTheme extends ConsumerStatefulWidget {
  const GraphicTheme({super.key});

  @override
  ConsumerState<GraphicTheme> createState() => _GraphicThemeState();
}

class _GraphicThemeState extends ConsumerState<GraphicTheme> {
  String? _selectedTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            MarkdownTooltip(
              message: '''

              **Graphic Theme Setting:** The graphic theme is used
              by many (but not all) of the plots in Rattle, and
              specifically by those plots using the ggplot2
              package. Hover over each theme for more details. The
              default is the Rattle theme.

              ''',
              child: Text(
                'Graphic Theme',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            configRowGap,
            MarkdownTooltip(
              message: '''

              **Reset Theme:** Tap here to reset the Graphic Theme
                setting to the default theme for Rattle.
                
              ''',
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedTheme = 'theme_rattle';
                  });
                  ref
                      .read(settingsGraphicThemeProvider.notifier)
                      .setGraphicTheme(_selectedTheme!);
                  rSource(context, ref, ['settings']);
                },
                child: const Text('Reset'),
              ),
            ),
          ],
        ),
        configRowGap,
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: themeOptions.map((option) {
            return MarkdownTooltip(
              message: option['tooltip']!,
              child: ChoiceChip(
                label: Text(option['label']!),
                selected: _selectedTheme == option['value'],
                onSelected: (bool selected) {
                  setState(() {
                    _selectedTheme = option['value'];
                  });
                  ref
                      .read(settingsGraphicThemeProvider.notifier)
                      .setGraphicTheme(_selectedTheme!);
                  rSource(context, ref, ['settings']);
                },
              ),
            );
          }).toList(),
        ),
        settingsGroupGap,
        Divider(),
      ],
    );
  }
}
