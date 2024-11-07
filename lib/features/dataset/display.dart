/// Dataset display with pages.
//
// Time-stamp: <Thursday 2024-11-07 17:06:27 +1100 Graham Williams>
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
/// Authors: Graham Williams, Yixiang Yin， Bo Zhang, Kevin Wang

library;

import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/app.dart';
import 'package:rattle/constants/markdown.dart';
import 'package:rattle/constants/spacing.dart';
import 'package:rattle/providers/meta_data.dart';
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/providers/path.dart';
import 'package:rattle/providers/vars/roles.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/providers/vars/types.dart';
import 'package:rattle/r/execute.dart';
import 'package:rattle/r/extract.dart';
import 'package:rattle/r/extract_large_factors.dart';
import 'package:rattle/r/extract_vars.dart';
import 'package:rattle/utils/get_target.dart';
import 'package:rattle/utils/get_unique_columns.dart';
import 'package:rattle/utils/is_numeric.dart';
import 'package:rattle/utils/show_ok.dart';
import 'package:rattle/utils/update_roles_provider.dart';
import 'package:rattle/utils/update_meta_data.dart';
import 'package:rattle/utils/debug_text.dart';
import 'package:rattle/widgets/delayed_tooltip.dart';
import 'package:rattle/widgets/page_viewer.dart';
import 'package:rattle/utils/show_markdown_file_2.dart';
import 'package:rattle/widgets/text_page.dart';

const smallSpace = SizedBox(height: 10);

/// The dataset panel displays the RattleNG welcome on the first page and the
/// ROLES as the second page.

class DatasetDisplay extends ConsumerStatefulWidget {
  const DatasetDisplay({super.key});

  @override
  ConsumerState<DatasetDisplay> createState() => _DatasetDisplayState();
}

class _DatasetDisplayState extends ConsumerState<DatasetDisplay> {
  // Constants for layout.

  final int typeFlex = 4;
  final int contentFlex = 3;

  @override
  Widget build(BuildContext context) {
    final pageController = ref
        .watch(pageControllerProvider); // Get the PageController from Riverpod

    String path = ref.watch(pathProvider);
    String stdout = ref.watch(stdoutProvider);

    // FIRST PAGE: Welcome Message

    List<Widget> pages = [
      showMarkdownFile2(welcomeIntroFile1, welcomeIntroFile2, context),
    ];

    // Handle different file types

    if (path.endsWith('.txt')) {
      _addTextFilePage(stdout, pages);
    } else if (path == weatherDemoFile || path.endsWith('.csv')) {
      // 20240815 gjw Update the metaData provider here if needed.

      updateMetaData(ref);

      _addDatasetPage(stdout, pages);
    }

    return PageViewer(
      pageController: pageController,
      pages: pages,
    );
  }

  ////////////////////////////////////////////////////////////////////////

  // Add a page for text file (a .txt file) content for Word Cloud.

  void _addTextFilePage(String stdout, List<Widget> pages) {
    String content = rExtract(stdout, '> cat(ds,');
    String title = '''

        # Text Content

        Generated using
        [base::cat(ds)](https://www.rdocumentation.org/packages/base/topics/cat).

        ''';

    if (content.isNotEmpty) {
      pages.add(TextPage(title: title, content: '\n$content'));
    }
  }

  ////////////////////////////////////////////////////////////////////////

  // Add a page for dataset summary.
  void _addDatasetPage(String stdout, List<Widget> pages) {
    Map<String, Role> currentRoles = ref.read(rolesProvider);
    List<VariableInfo> vars = extractVariables(stdout);
    List<String> highVars = extractLargeFactors(stdout);

    _initializeRoles(vars, highVars, currentRoles);

    // When a new row is added after transformation, initialize its role and
    // update the role of the old variable.

    updateVariablesProvider(ref);

    pages.add(
      Stack(
        children: [
          // Positioned DelayedTooltip in the top-right corner.

          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: DelayedTooltip(
                message: '''
              
              Viewer: Tap here to open a separate window to view the current
              dataset. The default and quite simple data viewer in R will be
              used. It is invoked as `view(ds)`.

              ''',
                child: IconButton(
                  icon: const Icon(
                    Icons.table_view,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    String path = ref.read(pathProvider);
                    if (path.isEmpty) {
                      showOk(
                        context: context,
                        title: 'No Dataset Loaded',
                        content: '''

                      Please choose a dataset to load from the **Dataset** tab. There is
                      not much we can do until we have loaded a dataset.

                      ''',
                      );
                    } else {
                      rExecute(ref, 'View(ds)\n');
                    }
                  },
                ),
              ),
            ),
          ),

          // Main ListView for displaying data table.

          Padding(
            padding: const EdgeInsets.only(top: 56.0),
            child: ListView.builder(
              key: const Key('roles_list_view'),

              // Item count is the same as the number of variables.
              itemCount: vars.length,

              itemBuilder: (context, index) {
                // Show header only for the first row.
                return _buildDataTable(
                  vars[index],
                  currentRoles,
                  showHeader: index == 0,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Initialise ROLES. Default to INPUT and identify TARGET, RISK,
  // IDENTS. Also record variable types.

  void _initializeRoles(
    List<VariableInfo> vars,
    List<String> highVars,
    Map<String, Role> currentRoles,
  ) {
    if (currentRoles.isEmpty && vars.isNotEmpty) {
      for (var column in vars) {
        _setInitialRole(column, ref);
      }
      _setTargetRole(vars, ref);
      _setIdentRole(ref);
      _setIgnoreRoleForHighVars(highVars, ref);
    }
  }

  // Set initial role for a variable.

  void _setInitialRole(VariableInfo column, WidgetRef ref) {
    String name = column.name.toLowerCase();

    // Default is INPUT unless a prefix is found.

    Role role = Role.input;

    if (name.startsWith('risk_')) role = Role.risk;
    if (name.startsWith('ignore_')) role = Role.ignore;
    if (name.startsWith('target_')) role = Role.target;

    ref.read(rolesProvider.notifier).state[column.name] = role;
    ref.read(typesProvider.notifier).state[column.name] =
        isNumeric(column.type) ? Type.numeric : Type.categoric;
  }

  // Treat the last variable as a TARGET by default. We will eventually
  // implement Rattle heuristics to identify the TARGET if the final
  // variable has more than 5 levels. If so we'll check if the first
  // variable looks like a TARGET (another common practise) and if not
  // then no TARGET will be identified by default.

  void _setTargetRole(List<VariableInfo> vars, WidgetRef ref) {
    String target = getTarget(ref);
    if (target == 'NULL') {
      ref.read(rolesProvider.notifier).state[vars.last.name] = Role.target;
    } else {
      ref.read(rolesProvider.notifier).state[target] = Role.target;
    }
  }

  // Any variables that have a unique value for every row in the dataset
  // is considered to be an IDENTifier.

  void _setIdentRole(WidgetRef ref) {
    for (var id in getUniqueColumns(ref)) {
      ref.read(rolesProvider.notifier).state[id] = Role.ident;
    }
  }

  // Set ignore role for high cardinality variables.

  void _setIgnoreRoleForHighVars(List<String> highVars, WidgetRef ref) {
    for (var highVar in highVars) {
      if (ref.read(rolesProvider.notifier).state[highVar] != Role.target) {
        ref.read(rolesProvider.notifier).state[highVar] = Role.ignore;
      }
    }
  }

  // Build data line for each variable, including the table header if specified.

  Widget _buildDataTable(
    VariableInfo variable,
    Map<String, Role> currentRoles, {
    bool showHeader = false,
  }) {
    // Truncate the content to fit one line. The text could wrap over two
    // lines and so show more of the data, but our point here is more to
    // have a reminder of the data to assist in deciding on the ROLE of each
    // variable, not any real insight into the data which we leave to the
    // SUMMARY feature.

    String content = _truncateContent(variable.details);

    // Extract unique and missing values from metaDataProvider.

    Map<String, dynamic> metaData = ref.watch(metaDataProvider);
    int uniqueCount = metaData[variable.name]?['unique']?[0] ?? 0;
    int missingCount = metaData[variable.name]?['missing']?[0] ?? 0;

    var formatter = NumberFormat('#,###');

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Table(
        columnWidths: const {
          // Variable name column.
          0: FixedColumnWidth(150.0),
          // Role column.
          1: FixedColumnWidth(400.0),
          // Type column.
          2: FixedColumnWidth(40.0),
          // Unique column.
          3: FixedColumnWidth(80.0),
          // Missing column.
          4: FixedColumnWidth(80.0),
          // Gap of 20px between the columns
          5: FixedColumnWidth(20.0),
          // Content column.
          6: FlexColumnWidth(),
        },
        children: [
          if (showHeader)
            // Table header row.

            const TableRow(
              children: [
                // Header for variable name.

                Text(
                  'Variable',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),

                // Header for role.

                Text(
                  'Role',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),

                // Header for type.

                Text(
                  'Type',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),

                // Header for unique count.

                Text(
                  'Unique',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),

                // Header for missing count.

                Text(
                  'Missing',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),

                // Empty cell acting as a gap

                SizedBox.shrink(),

                // Header for content.

                Text(
                  'Sample',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ],
            ),

          // Extra space after header row.

          TableRow(
            children: [
              smallSpace,
              smallSpace,
              smallSpace,
              smallSpace,
              smallSpace,
              smallSpace,
              smallSpace,
            ],
          ),

          // Table data row for variable.

          TableRow(
            children: [
              // Variable name column.

              _buildFittedText(variable.name),

              // Role choice chips column.

              _buildRoleChips(variable.name, currentRoles),

              // Variable type column.

              Text(
                variable.type,
                textAlign: TextAlign.center,
              ),

              // Unique count column.

              Text(
                formatter.format(uniqueCount),
                textAlign: TextAlign.right,
              ),

              // Missing count column.

              Text(
                formatter.format(missingCount),
                textAlign: TextAlign.right,
              ),

              // Empty cell acting as a gap

              SizedBox.shrink(),
              // Content column.

              SelectableText(
                content,
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Build fitted text for variable name.

  Widget _buildFittedText(String text) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.topLeft,
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.left,
      ),
    );
  }

  // Build role choice chips.

  Widget _buildRoleChips(String columnName, Map<String, Role> currentRoles) {
    return Center(
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
            onSelected: (bool selected) => _handleRoleSelection(
              selected,
              choice,
              columnName,
              currentRoles,
            ),
          );
        }).toList(),
      ),
    );
  }

  // Handle role selection.

  void _handleRoleSelection(
    bool selected,
    Role choice,
    String columnName,
    Map<String, Role> currentRoles,
  ) {
    // The parameter selected can be false when a chip
    // is tapped when it is already selected.  In our
    // case we need do nothing else. That could be
    // useful as a toggle button!

    setState(() {
      if (selected) {
        // Only one variable can be TARGET, RISK and
        // WEIGHT so any previous variable with that
        // role shold become INPUT.

        if (choice == Role.target ||
            choice == Role.risk ||
            choice == Role.weight) {
          currentRoles.forEach((key, value) {
            if (value == choice) {
              ref.read(rolesProvider.notifier).state[key] = Role.input;
            }
          });
        }
        ref.read(rolesProvider.notifier).state[columnName] = choice;
        debugText('  $choice', columnName);
      }
    });
  }

  // Truncate content for display.

  String _truncateContent(String content) {
    int maxLength = 45;
    String subStr =
        content.length > maxLength ? content.substring(0, maxLength) : content;
    int lastCommaIndex = subStr.lastIndexOf(',') + 1;

    return '${lastCommaIndex > 0 ? content.substring(0, lastCommaIndex) : subStr} ...';
  }
}
