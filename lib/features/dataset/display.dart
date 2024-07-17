/// Widget to display the Rattle introduction or data view.
//
// Time-stamp: <Monday 2024-07-15 08:00:25 +1000 Graham Williams>
//
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
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

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'package:flutter/material.dart';
//import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:path_provider/path_provider.dart';

import 'package:rattle/constants/app.dart';
import 'package:rattle/providers/path.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/providers/selections.dart';
//import 'package:rattle/constants/temp_dir.dart';
import 'package:rattle/r/extract_glimpse.dart';
import 'package:rattle/r/extract_vars.dart';
import 'package:rattle/widgets/pages.dart';
import 'package:rattle/widgets/show_markdown_file.dart';
import 'package:rattle/widgets/text_page.dart';

/// The dataset panel displays the RattleNG welcome or a data summary.

class DatasetDisplay extends ConsumerStatefulWidget {
  const DatasetDisplay({super.key});

  @override
  ConsumerState<DatasetDisplay> createState() => _DatasetDisplayState();
}

class _DatasetDisplayState extends ConsumerState<DatasetDisplay> {
  Widget space = const SizedBox(
    width: 10,
  );
  int typeFlex = 4;
  int contentFlex = 3;
  List<String> choices = [
    'Input',
    'Target',
    'Risk',
    'Ident',
    'Ignore',
    'Weight',
  ];

  @override
  Widget build(BuildContext context) {
    String path = ref.watch(pathProvider);
    String stdout = ref.watch(stdoutProvider);

    List<Widget> pages = [showMarkdownFile(welcomeMsgFile, context)];

    if (path == 'rattle::weather' || path.endsWith('.csv')) {
      Map<String, String> currentSelections = ref.read(selectionsProvider);
      // extract variable information
      List<VariableInfo> vars = extractVariables(stdout);
      // initialise, default to input
      if (currentSelections.isEmpty && vars.isNotEmpty) {
        for (var column in vars) {
          ref.read(selectionsProvider.notifier).state[column.name] =
              choices.first;
        }
      }

      var headline = Padding(
        padding: const EdgeInsets.all(6.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(
              child: Text(
                'Variable',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            space,
            const Expanded(
              child: Text(
                'Type',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            space,
            Expanded(
              flex: typeFlex,
              child: const Text(
                'Role',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            space,
            Expanded(
              flex: contentFlex,
              child: const Text(
                'Content',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );

      Widget dataline(columnName, dataType, content) {
        // Generate the row for a data line.

        // Truncate the content to fite the Role boses on one line.

        int maxLength = 40;
        // Extract substring of the first maxLength characters
        String subStr = content.length > maxLength
            ? content.substring(0, maxLength)
            : content;
        // Find the last comma in the substring
        int lastCommaIndex = subStr.lastIndexOf(',') + 1;
        content =
            lastCommaIndex > 0 ? content.substring(0, lastCommaIndex) : subStr;
        content += ' ...';

        return Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(columnName),
              ),
              space,
              Expanded(
                child: Text(dataType),
              ),
              space,
              Expanded(
                flex: typeFlex,
                child: Wrap(
                  spacing: 5.0,
                  children: choices.map((choice) {
                    return ChoiceChip(
                      label: Text(choice),
                      disabledColor: Colors.grey,
                      selectedColor: Colors.lightBlue[200],
                      backgroundColor: Colors.lightBlue[50],
                      shadowColor: Colors.grey,
                      pressElevation: 8.0,
                      elevation: 2.0,
                      selected: currentSelections[columnName] == choice,
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            // only one variable is Target, Risk and Weight.
                            if (choice == 'Target' || choice == 'Risk' || choice == 'Weight') {
                              currentSelections.forEach((key, value) {
                                if (value == choice) {
                                  ref.read(selectionsProvider.notifier).state[key] = 'Input';
                                }
                              });
                            }
                            ref
                                .read(selectionsProvider.notifier)
                                .state[columnName] = choice;
                            debugPrint('$columnName set to $choice');
                          } else {
                            ref
                                .read(selectionsProvider.notifier)
                                .state[columnName] = '';
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              space,
              Expanded(
                flex: contentFlex,
                child: Text(
                  content,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        );
      }

      pages.add(
        ListView.builder(
          itemCount: vars.length + 1, // Add 1 for the extra header row
          itemBuilder: (context, index) {
            // both the header row and the regular row shares the same flex index
            if (index == 0) {
              // Render the extra header row
              return headline;
            } else {
              // Regular data rows
              final variableIndex = index - 1; // Adjust index for regular data
              String columnName = vars[variableIndex].name;
              String dataType = vars[variableIndex].type;
              String content = vars[variableIndex].details;

              return dataline(columnName, dataType, content);
            }
          },
        ),
      );
    }

    String content = rExtractGlimpse(stdout);

    if (content.isNotEmpty) {
      pages.add(
        TextPage(
          title: '# Dataset Glimpse\n\n'
              'Generated using `glimpse(ds)`',
          content: '\n$content',
        ),
      );
    }

    return Pages(children: pages);
  }
}
