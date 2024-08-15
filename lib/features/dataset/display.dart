/// Dataset display with three pages: Overview, Glimpse, Roles.
//
// Time-stamp: <Thursday 2024-08-15 15:04:52 +1000 Graham Williams>
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
/// Authors: Graham Williams, Yixiang Yin

library;

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/app.dart';
import 'package:rattle/constants/spacing.dart';
import 'package:rattle/providers/path.dart';
import 'package:rattle/providers/vars/roles.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/providers/vars/types.dart';
import 'package:rattle/r/extract.dart';
import 'package:rattle/r/extract_glimpse.dart';
import 'package:rattle/r/extract_vars.dart';
import 'package:rattle/utils/get_target.dart';
import 'package:rattle/utils/get_unique_columns.dart';
import 'package:rattle/utils/is_numeric.dart';
import 'package:rattle/utils/update_roles_provider.dart';
import 'package:rattle/utils/update_meta_data.dart';
import 'package:rattle/widgets/pages.dart';
import 'package:rattle/widgets/show_markdown_file.dart';
import 'package:rattle/widgets/text_page.dart';
import 'package:rattle/providers/meta_data.dart';

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

  @override
  Widget build(BuildContext context) {
    String path = ref.watch(pathProvider);
    String stdout = ref.watch(stdoutProvider);

    // FIRST PAGE: Welcome Message

    List<Widget> pages = [showMarkdownFile(welcomeMsgFile, context)];

    String content = '';
    String title = '';

    if (path == weatherDemoFile || path.endsWith('.csv')) {
      content = rExtractGlimpse(stdout);
      title = '''

      # Dataset Glimpse

      Generated using
      [dplyr::glimpse(ds)](https://www.rdocumentation.org/packages/dplyr/topics/glimpse).

      ''';
    } else {
      content = rExtract(stdout, '> cat(ds,');
      title = '''

      # Text Content

      Generated using
      [base::cat(ds)](https://www.rdocumentation.org/packages/base/topics/cat).

      ''';
    }

    if (content.isNotEmpty) {
      pages.add(
        TextPage(
          title: title,
          content: '\n$content',
        ),
      );
    }

    if (path == weatherDemoFile || path.endsWith('.csv')) {
      // A new dataset has been loaded so we update the information here.

      Map<String, Role> currentRoles = ref.read(rolesProvider);

      // Extract variable information from the R console.

      List<VariableInfo> vars = extractVariables(stdout);

      // 20240815 gjw Update the metaData provider here if needed.

      updateMetaData(ref);
      Map<String, dynamic> meta = ref.read(metaDataProvider);
      if (meta.isNotEmpty) {
        debugPrint('META TARGET: ${vars.last.name}');
        debugPrint('META TARGET: ${meta[vars.last.name]}');
        debugPrint('META TARGET: ${meta[vars.last.name]["unique"]}');
      }

      // Initialise ROLES. Default to INPUT and identify TARGET, RISK,
      // IDENTS. Also record variable types.

      if (currentRoles.isEmpty && vars.isNotEmpty) {
        // Default is INPUT unless the variable name begins with `risk_`.
        debugPrint('DATASET DISPLAY => changing types provider.');
        for (var column in vars) {
          ref.read(rolesProvider.notifier).state[column.name] = Role.input;
          ref.read(typesProvider.notifier).state[column.name] =
              isNumeric(column.type) ? Type.numeric : Type.categoric;

          if (column.name.toLowerCase().startsWith('risk_')) {
            ref.read(rolesProvider.notifier).state[column.name] = Role.risk;
          }

          if (column.name.toLowerCase().startsWith('ignore_')) {
            ref.read(rolesProvider.notifier).state[column.name] = Role.ignore;
          }

          if (column.name.toLowerCase().startsWith('target_')) {
            ref.read(rolesProvider.notifier).state[column.name] = Role.target;
          }
        }

        // Treat the last variable as a TARGET by default, except if it has more
        // than 5 levels. TODO If so we'll check if the first variable looks
        // like a TARGET (another common practise) and if not then find the cat
        // vartiable with least levels as TARGET.

        if (getTarget(ref) == 'NULL') {
          // 20240815 gjw Note that because of the async nature meta is not yet
          // avails which is problematic.
          if (meta.isNotEmpty) {
            if (ref.read(typesProvider)[vars.last.name] == Type.categoric &&
                meta[vars.last.name]['unique'] < 5) {
              ref.read(rolesProvider.notifier).state[vars.last.name] =
                  Role.target;
            } else {
              debugPrint(
                  'DATASET DISPLAY: Not set ${vars.last.name} as TARGET');
            }
          }
          // TODO 20240814 gjw LAST COLUMN NUMERIC THEN TARGET IS OTHER CATEGORIC
          //
          // Look for the firts factor with the least number of levels.
        }

        // Any variables that have a unique value for every row in the dataset
        // is considered to be an IDENTifier.

        for (var id in getUniqueColumns(ref)) {
          ref.read(rolesProvider.notifier).state[id] = Role.ident;
        }
      }
      // When a new row is added after transformation, initialise its role and update the role of the old variable
      updateVariablesProvider(ref);

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
                  runSpacing: choiceChipRowSpace,
                  children: choices.map((choice) {
                    return ChoiceChip(
                      label: Text(choice.displayString),
                      disabledColor: Colors.grey,
                      selectedColor: Colors.lightBlue[200],
                      backgroundColor: Colors.lightBlue[50],
                      shadowColor: Colors.grey,
                      pressElevation: 8.0,
                      elevation: 2.0,
                      selected: remap(currentRoles[columnName]!, choice),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            // only one variable is Target, Risk and Weight.
                            if (choice == Role.target ||
                                choice == Role.risk ||
                                choice == Role.weight) {
                              currentRoles.forEach((key, value) {
                                if (value == choice) {
                                  ref.read(rolesProvider.notifier).state[key] =
                                      Role.input;
                                }
                              });
                            }
                            ref.read(rolesProvider.notifier).state[columnName] =
                                choice;
                            debugPrint('$columnName set to $choice');
                          } else {
                            debugPrint('This should not happen');
                            // ref.read(rolesProvider.notifier).state[columnName] =
                            //     ;
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

    return Pages(children: pages);
  }
}
