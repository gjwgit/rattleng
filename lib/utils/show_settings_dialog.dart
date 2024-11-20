/// Display the settings dialog.
//
// Time-stamp: <Tuesday 2024-11-19 11:58:45 +1100 Graham Williams>
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
/// Authors: Graham Williams

library;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/providers/settings.dart';
import 'package:rattle/r/source.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';

/// List of available ggplot themes for the user to choose from.

const List<Map<String, String>> themeOptions = [
  {
    'label': 'Rattle',
    'value': 'theme_rattle',
    'tooltip': 'The default theme used in Rattle.',
  },
  {
    'label': 'Base',
    'value': 'ggthemes::theme_base',
    'tooltip': "A theme based on R's Base plotting system.",
  },
  {
    'label': 'Black and White',
    'value': 'ggplot2::theme_bw',
    'tooltip': '''

        A theme with a white background and black grid lines, often used for
        publication quality plots.

        ''',
  },
  {
    'label': 'Calc',
    'value': 'ggthemes::theme_calc',
    'tooltip': 'A theme based on the Calc spreadsheet.',
  },
  {
    'label': 'Classic',
    'value': 'ggplot2::theme_classic',
    'tooltip': '''

        A theme resembling base R graphics, with a white background and no
        gridlines.

        ''',
  },
  {
    'label': 'Dark',
    'value': 'ggplot2::theme_dark',
    'tooltip': '''

        A theme with a dark background and white grid lines, useful for dark
        mode or high contrast needs.

        ''',
  },
  {
    'label': 'Economist',
    'value': 'ggthemes::theme_economist',
    'tooltip': 'A theme inspired by The Economist journal.',
  },
  {
    'label': 'Excel',
    'value': 'ggthemes::theme_excel',
    'tooltip': 'A theme inspired by the Excel spreadsheet.',
  },
  {
    'label': 'Few',
    'value': 'ggthemes::theme_few',
    'tooltip': "A theme based on Few's work.",
  },
  {
    'label': 'Fivethirtyeight',
    'value': 'ggthemes::theme_fivethirtyeight',
    'tooltip': 'A theme inspired by the FiveThirtyEight website.',
  },
  {
    'label': 'Foundation',
    'value': 'ggthemes::theme_foundation',
    'tooltip': "A theme based on Zurb's Foundation.",
  },
  {
    'label': 'Gdocs',
    'value': 'ggthemes::theme_gdocs',
    'tooltip': 'A theme inspired by Google Docs.',
  },
  {
    'label': 'Grey',
    'value': 'ggplot2::theme_grey',
    'tooltip': 'The default theme of ggplot2, with a grey background.',
  },
  {
    'label': 'Highcharts',
    'value': 'ggthemes::theme_hc',
    'tooltip': 'A theme inspired by Highcharts.',
  },
  {
    'label': 'IGray',
    'value': 'ggthemes::theme_igray',
    'tooltip': 'A minimalist grayscale theme.',
  },
  {
    'label': 'Light',
    'value': 'ggplot2::theme_light',
    'tooltip': 'A theme with a light grey background and white grid lines.',
  },
  {
    'label': 'Linedraw',
    'value': 'ggplot2::theme_linedraw',
    'tooltip':
        'A theme with black and white line drawings, without color shading.',
  },
  {
    'label': 'Minimal',
    'value': 'ggplot2::theme_minimal',
    'tooltip':
        'A minimalistic theme with no background annotations and grid lines.',
  },
  {
    'label': 'Pander',
    'value': 'ggthemes::theme_pander',
    'tooltip': "A theme inspired by Pandoc's pander package.",
  },
  {
    'label': 'Solarized',
    'value': 'ggthemes::theme_solarized',
    'tooltip': 'a theme based on the Solarized color scheme.',
  },
  {
    'label': 'Stata',
    'value': 'ggthemes::theme_stata',
    'tooltip': 'A theme inspired by the Stata software.',
  },
  {
    'label': 'Tufte',
    'value': 'ggthemes::theme_tufte',
    'tooltip': 'A theme inspired by Edward Tufte.',
  },
  {
    'label': 'Void',
    'value': 'ggplot2::theme_void',
    'tooltip': '''

        A completely blank theme, useful for creating annotations or background-less plots

        ''',
  },
  {
    'label': 'Wall Street Journal',
    'value': 'ggthemes::theme_wsj',
    'tooltip': 'A theme inspired by the Wall Street Journal.',
  },
];

void showSettingsDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierLabel: 'Settings',
    barrierDismissible: true,
    barrierColor: Colors.black54, // Darken the background
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, anim1, anim2) {
      return const Align(
        alignment: Alignment.center,
        child: SettingsDialog(),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: anim1, curve: Curves.easeOut),
        child: child,
      );
    },
  );
}

class SettingsDialog extends ConsumerStatefulWidget {
  const SettingsDialog({super.key});

  @override
  SettingsDialogState createState() => SettingsDialogState();
}

class SettingsDialogState extends ConsumerState<SettingsDialog> {
  String? _selectedTheme;

  @override
  void initState() {
    super.initState();

    // Get the current theme from the Riverpod provider.

    _selectedTheme = ref.read(settingsGraphicThemeProvider);

    // Automatically update the theme in Riverpod when the dialog is opened.

    ref
        .read(settingsGraphicThemeProvider.notifier)
        .setGraphicTheme(_selectedTheme!);

    rSource(context, ref, ['settings']);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size; // Get screen size.

    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Stack(
          children: [
            Container(
              // Full screen width.

              width: size.width,
              // Full screen height.

              height: size.height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Select Graphic Theme',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: themeOptions.map((option) {
                        return MarkdownTooltip(
                          // Tooltip for each chip.

                          message: option['tooltip']!,

                          child: ChoiceChip(
                            label: Text(option['label']!),
                            selected: _selectedTheme == option['value'],
                            onSelected: (bool selected) {
                              setState(() {
                                _selectedTheme = option['value'];
                              });

                              // Automatically update the theme in Riverpod.

                              ref
                                  .read(settingsGraphicThemeProvider.notifier)
                                  .setGraphicTheme(_selectedTheme!);

                              rSource(context, ref, ['settings']);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    // Add the RESTORE button to reset to factory default theme.

                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedTheme = 'theme_rattle';
                        });

                        // Reset to default theme in provider and persist it.

                        ref
                            .read(settingsGraphicThemeProvider.notifier)
                            .setGraphicTheme(_selectedTheme!);

                        rSource(context, ref, ['settings']);
                      },
                      child: const Text('RESTORE'),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
                tooltip: 'Cancel',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
