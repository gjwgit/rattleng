/// Widget to display the Rattle introduction or data view.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Friday 2024-06-14 14:28:13 +1000 Graham Williams>
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

import 'package:rattle/constants/app.dart';
import 'package:rattle/constants/keys.dart';
import 'package:rattle/providers/path.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/providers/variable_selection.dart';
import 'package:rattle/r/extract_glimpse.dart';
import 'package:rattle/r/extract_vars.dart';
import 'package:rattle/widgets/show_markdown_file.dart';

/// The dataset panel displays the RattleNG welcome or a data summary.

class DatasetPanel extends ConsumerStatefulWidget {
  const DatasetPanel({super.key});

  @override
  ConsumerState<DatasetPanel> createState() => _DatasetPanelState();
}

class _DatasetPanelState extends ConsumerState<DatasetPanel> {
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
    if (path == '') {
      return showMarkdownFile(welcomeMsgFile, context);
    } else if (path == 'rattle::weather' || path.endsWith('.csv')) {
      Map<String, String> currentSelections = ref.read(selectionsProvider);
      // extract variable information
      List<VariableInfo> vars = extractVariables(stdout);
      // initialise, default to input
      if (currentSelections.isEmpty && vars.isNotEmpty) {
        for (var column in vars) {
          ref.read(selectionsProvider.notifier).state[column.name] = choices[0];
        }
      }
      return ListView.builder(
        itemCount: vars.length + 1, // Add 1 for the extra header row
        itemBuilder: (context, index) {
          // both the header row and the regular row shares the same flex index
          if (index == 0) {
            // Render the extra header row
            return Padding(
              padding: EdgeInsets.all(6.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      'Variable',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  space,
                  Expanded(
                    child: Text(
                      'Data Type',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  space,
                  Expanded(
                    flex: typeFlex,
                    child: Text(
                      'Type',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  space,
                  Expanded(
                    flex: contentFlex,
                    child: Text(
                      'Content',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
          } else {
            // Regular data rows
            final variableIndex = index - 1; // Adjust index for regular data
            String columnName = vars[variableIndex].name;
            String dataType = vars[variableIndex].type;
            String content = vars[variableIndex].details;

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
                          selected: currentSelections[columnName] == choice,
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
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
                    child: Text(content),
                  ),
                ],
              ),
            );
          }
        },
      );
    } else {
      return Container(
        width: double.infinity,
        color: Colors.white,
        padding: const EdgeInsets.only(left: 10),
        child: SelectableText(
          rExtractGlimpse(stdout),
          key: datasetGlimpseKey,
          style: monoTextStyle,
        ),
      );
    }
  }
}
