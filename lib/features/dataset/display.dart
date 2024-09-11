/// Dataset display with three pages: Overview, Glimpse, Roles.
//
// Time-stamp: <Thursday 2024-09-12 08:31:36 +1000 Graham Williams>
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

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/app.dart';
import 'package:rattle/constants/spacing.dart';
import 'package:rattle/providers/path.dart';
import 'package:rattle/providers/vars/roles.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/providers/vars/types.dart';
import 'package:rattle/r/extract.dart';
import 'package:rattle/r/extract_vars.dart';
import 'package:rattle/utils/get_target.dart';
import 'package:rattle/utils/get_unique_columns.dart';
import 'package:rattle/utils/is_numeric.dart';
import 'package:rattle/utils/update_roles_provider.dart';
import 'package:rattle/utils/debug_text.dart';
import 'package:rattle/widgets/pages.dart';
import 'package:rattle/widgets/show_markdown_file.dart';
import 'package:rattle/widgets/text_page.dart';

TextStyle defaultTextStyle = const TextStyle(
  fontSize: 14,
);

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

    List<Widget> pages = [showMarkdownFile(welcomeMsgFile, context)];

    String content = '';
    String title = '';

    // 20240911 gjw Move the glimpse page to the SUMMARY feature.

    // if (path == weatherDemoFile || path.endsWith('.csv')) {
    //   content = rExtractGlimpse(stdout);
    //   title = '''

    //   # Dataset Glimpse

    //   Generated using
    //   [dplyr::glimpse(ds)](https://www.rdocumentation.org/packages/dplyr/topics/glimpse).

    //   ''';
    // } else {

    // Keep the TEXT page here for now.

    if (path.endsWith('.txt')) {
      content = rExtract(stdout, '> cat(ds,');
      title = '''

      # Text Content

      Generated using
      [base::cat(ds)](https://www.rdocumentation.org/packages/base/topics/cat).

      ''';

      if (content.isNotEmpty) {
        pages.add(
          TextPage(
            title: title,
            content: '\n$content',
          ),
        );
      }
    }

    ////////////////////////////////////////////////////////////////////////

    if (path == weatherDemoFile || path.endsWith('.csv')) {
      Map<String, Role> currentRoles = ref.read(rolesProvider);

      // Extract variable information from the R console.

      List<VariableInfo> vars = extractVariables(stdout);

      // Initialise ROLES. Default to INPUT and identify TARGET, RISK,
      // IDENTS. Also record variable types.

      if (currentRoles.isEmpty && vars.isNotEmpty) {
        // Default is INPUT unless the variable name begins with `risk_`.

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

        // Treat the last variable as a TARGET by default. We will eventually
        // implement Rattle heuristics to identify the TARGET if the final
        // variable has more than 5 levels. If so we'll check if the first
        // variable looks like a TARGET (another common practise) and if not
        // then no TARGET will be identified by default.

        if (getTarget(ref) == 'NULL') {
          ref.read(rolesProvider.notifier).state[vars.last.name] = Role.target;
        } else {
          ref.read(rolesProvider.notifier).state[getTarget(ref)] = Role.target;
        }

        // Any variables that have a unique value for every row in the dataset
        // is considered to be an IDENTifier.

        for (var id in getUniqueColumns(ref)) {
          ref.read(rolesProvider.notifier).state[id] = Role.ident;
        }
      }

      // When a new row is added after transformation, initialise its role and
      // update the role of the old variable

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

        // Truncate the content to fit one line. The text could wrap over two
        // lines and so show more of the data, but our point here is more to
        // have a reminder of the data to assist in deciding on the ROLE of each
        // variable, not any real insight into the data which we leave to the
        // SUMMARY feature.

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
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment
                          .centerLeft, // Aligns the content to the left
                      child: Text(
                        columnName,
                        style: defaultTextStyle,
                        maxLines: 1, // Ensure the text stays on one line
                        overflow: TextOverflow
                            .ellipsis, // Adds ellipsis if text overflows
                        textAlign: TextAlign
                            .left, // Aligns the text within the Text widget to the left
                      ),
                    ),
                  ),

                  space,
                  Expanded(
                    child: Text(dataType),
                  ),
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
                          showCheckmark: false,
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
                                      ref
                                          .read(rolesProvider.notifier)
                                          .state[key] = Role.input;
                                    }
                                  });
                                }
                                ref
                                    .read(rolesProvider.notifier)
                                    .state[columnName] = choice;
                                debugText('  $choice', columnName);
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
                  Expanded(
                    flex: contentFlex,
                    child: Text(
                      content,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  // Hard code the Spacer when the screen width is large.

                  // Add a Spacer if the screen width is greater than 1159.0.

                  if (constraints.maxWidth > 1159.0) const Spacer(),

                  // Two spacers to make the layout more compact.
                  // Add a Spacer if the screen width is greater than 1159.0.

                  if (constraints.maxWidth > 1159.0) const Spacer(),
                ],
              );
            },
          ),
        );
      }

      pages.add(
        ListView.builder(
          key: const Key('roles listView'),
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
