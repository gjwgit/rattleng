/// Graphic theme section.
//
// Time-stamp: <Monday 2025-01-06 15:20:25 +1100 Graham Williams>
//
/// Copyright (C) 2024, Togaware Pty Ltd
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU General Public License as published by the Free Software
// Foundation, either version 3 of the License, or (at your option) any later
// version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program.  If not, see <https://www.gnu.org/licenses/>.
///
/// Authors: Kevin Wang
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
