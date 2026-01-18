/// Dataset display with pages.
//
// Time-stamp: "Tuesday 2026-01-06 15:56:19 +1100 Graham Williams"
//
/// Copyright (C) 2023-2025, Togaware Pty Ltd.
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://opensource.org/license/gpl-3-0
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
// this program.  If not, see <https://opensource.org/license/gpl-3-0>.
///
/// Authors: Graham Williams, Yixiang Yin， Bo Zhang, Kevin Wang

library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';
import 'package:universal_io/io.dart';

import 'package:rattle/constants/markdown.dart';
import 'package:rattle/constants/spacing.dart';
import 'package:rattle/features/dataset/add_corpus_page.dart';
import 'package:rattle/features/dataset/add_text_file_page.dart';
import 'package:rattle/features/dataset/initialise_roles.dart';
import 'package:rattle/providers/meta_data.dart';
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/providers/path.dart';
import 'package:rattle/providers/roles_table_rebuild.dart';
import 'package:rattle/providers/selected_row.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/providers/vars/roles.dart';
import 'package:rattle/r/execute.dart';
import 'package:rattle/r/extract_vars.dart';
import 'package:rattle/utils/debug_text.dart';
import 'package:rattle/utils/get_large_factors.dart';
import 'package:rattle/utils/save_dataset_button.dart';
import 'package:rattle/utils/show_markdown_file_2.dart';
import 'package:rattle/utils/show_ok.dart';
import 'package:rattle/utils/truncate_content.dart';
import 'package:rattle/utils/update_meta_data.dart';
import 'package:rattle/utils/update_roles_provider.dart';
import 'package:rattle/widgets/page_viewer.dart';

/// The dataset panel displays the Rattle welcome on the first page and the
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

  // Track pressed keys for shift and control selection.

  bool _isShiftPressed = false;
  bool _isCtrlPressed = false;

  @override
  Widget build(BuildContext context) {
    // Get the PageController from Riverpod.

    final pageController = ref.watch(pageControllerProvider);

    String path = ref.watch(pathProvider);
    String stdout = ref.watch(stdoutProvider);

    // Watch rebuildTriggerProvider to trigger a rebuild when its value changes.

    ref.watch(rebuildTriggerProvider);

    // FIRST PAGE: Welcome Message.

    List<Widget> pages = [
      showMarkdownFile2(welcomeIntroFile1, welcomeIntroFile2, context),
    ];

    // Handle different file types.

    if (path.endsWith('.txt')) {
      addTextFilePage(stdout, pages);
    } else if (Directory(path).existsSync()) {
      // Process as corpus if the path exists and is a directory.

      addCorpusPage(stdout, pages);
    } else if (path.endsWith('.csv') || path.endsWith('.xlsx')) {
      // 20240815 gjw Update the metaData provider here if needed.

      updateMetaData(ref);

      _addDatasetPage(stdout, pages);
    }

    // Listen for shift and control key events.

    HardwareKeyboard.instance.addHandler((event) {
      setState(() {
        _isShiftPressed = HardwareKeyboard.instance.logicalKeysPressed.contains(
              LogicalKeyboardKey.shiftLeft,
            ) ||
            HardwareKeyboard.instance.logicalKeysPressed.contains(
              LogicalKeyboardKey.shiftRight,
            );

        _isCtrlPressed = HardwareKeyboard.instance.logicalKeysPressed.contains(
              LogicalKeyboardKey.controlLeft,
            ) ||
            HardwareKeyboard.instance.logicalKeysPressed.contains(
              LogicalKeyboardKey.controlRight,
            );
      });

      return false;
    });

    return PageViewer(pageController: pageController, pages: pages);
  }

  ////////////////////////////////////////////////////////////////////////

  // Add a page for dataset summary.

  void _addDatasetPage(String stdout, List<Widget> pages) {
    Map<String, Role> currentRoles = ref.read(rolesProvider);
    List<VariableInfo> vars = extractVariables(stdout);
    List<String> highVars = getLargeFactors(ref);

    initialiseRoles(vars, highVars, currentRoles, ref);

    // When a new row is added after transformation, initialize its role and
    // update the role of the old variable.

    updateVariablesProvider(ref);

    Map<String, String> rolesOption = {
      'Ignore': '''

      For the selected variables in the data table below set their role to
      **Ignore**.

      To select or deselect **all variables** SHIFT-click the checkbox in the
      header row. SHIFT click will also add/remove variables, and CTRL will
      add/remove all variables to the last click.

      Ignored variables will not be used in any analysis and can be removed from
      the dataset using the **Cleanup** feature under the **Transform** tab.

      ''',
      'Input': '''

      For the slected variables in the data table below set their role to
      **Input**.

      To select or deselect **all variables** shift-click the checkbox in the
      header row. SHIFT click will also add/remove variables, and CTRL will
      add/remove all variables to the last click.

      Input variables are used for predictive modelling in the **Model** tab,
      for example, to predict a **Target** variable.

      ''',
    };

    // Function to update the role for multiple selected rows.

    void updateRoleForSelectedRows(String newRole) {
      setState(() {
        final selectedRows = ref.read(selectedRowIndicesProvider);
        String stdout = ref.watch(stdoutProvider);

        List<VariableInfo> vars = extractVariables(stdout);

        // Update roles for each selected row

        for (var index in selectedRows) {
          String columnName = vars[index].name;
          ref.read(rolesProvider.notifier).state[columnName] =
              newRole == 'Ignore' ? Role.ignore : Role.input;
        }

        // Clear selection after updating

        selectedRows.clear();

        // Increment the rebuild trigger to refresh DatasetDisplay

        ref.read(rebuildTriggerProvider.notifier).state++;
      });
    }

    pages.add(
      Stack(
        children: [
          Row(
            children: [
              configWidgetGap,
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ...rolesOption.keys.map(
                      (roleKey) => MarkdownTooltip(
                        message: rolesOption[roleKey]!,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: ElevatedButton(
                            onPressed: () {
                              final selectedRows = ref.read(
                                selectedRowIndicesProvider,
                              );

                              if (selectedRows.isEmpty) {
                                // Show a warning dialog if no rows are selected.

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('No Row Selected'),
                                      content: const Text(
                                        'You have not selected a row to set the Role.',
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                // Proceed to update the role if rows are selected.

                                updateRoleForSelectedRows(roleKey);
                              }
                            },
                            child: Text(roleKey),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SaveDatasetButton(),
              configChooserGap,
              MarkdownTooltip(
                message: '''

                **Viewer.** Tap here to open a separate window to view the
                current dataset. The default and quite simple data viewer in R
                will be used. It is invoked as `View(ds)`.

                ''',
                child: IconButton(
                  icon: const Icon(Icons.table_view, color: Colors.blue),
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
                      rExecute(ref, 'View(ds)');
                    }
                  },
                ),
              ),
            ],
          ),

          // Main ListView for displaying data table.
          Padding(
            padding: const EdgeInsets.only(top: 56.0),
            child: _buildDataTable(vars),
          ),
        ],
      ),
    );
  }

  // Set ignore role for high cardinality variables.

  // 20241213 gjw Remove this for now until we decide how to best deal with
  // identifying variables to IGNORE.

  // void _setIgnoreRoleForHighVars(List<String> highVars, WidgetRef ref) {
  //   for (var highVar in highVars) {
  //     if (ref.read(rolesProvider.notifier).state[highVar] != Role.target) {
  //       ref.read(rolesProvider.notifier).state[highVar] = Role.ignore;
  //     }
  //   }
  // }

  // Build data table with row selection logic.

  Widget _buildDataTable(List<VariableInfo> vars) {
    Map<String, Role> currentRoles = ref.watch(rolesProvider);
    final selectedRows = ref.watch(selectedRowIndicesProvider);

    final ScrollController horizontalScrollController = ScrollController();

    var formatter = NumberFormat('#,###');

    return SizedBox(
      key: const Key('roles listView'),
      height: 800,
      child: Scrollbar(
        controller: horizontalScrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: horizontalScrollController,
          child: SizedBox(
            width: 1300, // Set the width to avoid truncated label.
            child: DataTable2(
              dataRowHeight: 60.0,
              checkboxAlignment: Alignment.centerLeft,
              columns: [
                const DataColumn2(
                  label: Text(
                    'Variable',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  size: ColumnSize.M,
                ),
                const DataColumn2(
                  label: Text(
                    'Role',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  fixedWidth: 450.0,
                ),
                const DataColumn2(
                  label: Text(
                    'Type',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  size: ColumnSize.S,
                ),
                const DataColumn2(
                  label: Text(
                    'Unique',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  size: ColumnSize.S,
                ),
                const DataColumn2(
                  label: Text(
                    'Missing',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  size: ColumnSize.S,
                ),
                const DataColumn2(
                  label: Text(
                    'Sample',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  size: ColumnSize.L,
                ),
              ],
              rows: vars.map((variable) {
                int rowIndex = vars.indexOf(variable);
                bool isSelected = selectedRows.contains(rowIndex);

                return DataRow(
                  selected: isSelected,
                  onSelectChanged: (bool? selected) {
                    setState(() {
                      if (selected == true) {
                        if (_isShiftPressed) {
                          // Shift-click: Add multiple selections from the last selected row.

                          selectedRows.add(rowIndex);
                        } else if (_isCtrlPressed && selectedRows.isNotEmpty) {
                          // Ctrl-click: Auto-select range between the first selected row and this row.

                          int firstSelectedRow = selectedRows.first;
                          int lastSelectedRow = rowIndex;

                          // Ensure that we have a start and end point correctly ordered.

                          if (lastSelectedRow < firstSelectedRow) {
                            int temp = firstSelectedRow;
                            firstSelectedRow = lastSelectedRow;
                            lastSelectedRow = temp;
                          }

                          // Select all rows in the range between first and last selected rows.

                          for (int i = firstSelectedRow;
                              i <= lastSelectedRow;
                              i++) {
                            selectedRows.add(i);
                          }
                        } else {
                          // Single click: Clear previous selection and select only the current row.

                          selectedRows.clear();
                          selectedRows.add(rowIndex);
                        }
                      } else {
                        // Deselect the row if it was previously selected.

                        selectedRows.remove(rowIndex);
                      }
                    });
                  },
                  cells: [
                    DataCell(Text(variable.name)),
                    DataCell(_buildRoleChips(variable.name, currentRoles)),
                    DataCell(Text(variable.type)),
                    DataCell(
                      Text(
                        formatter.format(
                          ref.watch(
                                metaDataProvider,
                              )[variable.name]?['unique']?[0] ??
                              0,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        formatter.format(
                          ref.watch(
                                metaDataProvider,
                              )[variable.name]?['missing']?[0] ??
                              0,
                        ),
                      ),
                    ),
                    DataCell(
                      SelectableText(truncateContent(variable.details)),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  // Build role choice chips.

  Widget _buildRoleChips(String columnName, Map<String, Role> currentRoles) {
    return Wrap(
      key: Key('role-$columnName'),
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
          // Selected if this chip's role (`choice`) matches the variable's
          // current role.  Defaults to `Role.ignore` if the variable
          // (`columnName`) has no assigned role. (zy 20250429)
          selected: remap(currentRoles[columnName] ?? Role.ignore, choice),
          onSelected: (bool selected) =>
              _handleRoleSelection(selected, choice, columnName, currentRoles),
        );
      }).toList(),
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
    // is tapped when it is already selected. That could
    // be useful as a toggle button.

    setState(() {
      if (selected) {
        // Only one variable can be TARGET, RISK, or WEIGHT, so any previous
        // variable with that role should become INPUT.

        if (choice == Role.target ||
            choice == Role.risk ||
            choice == Role.weight) {
          currentRoles.forEach((key, value) {
            if (value == choice) {
              ref.watch(rolesProvider.notifier).state[key] = Role.input;
            }
          });
        }
        ref.watch(rolesProvider.notifier).state[columnName] = choice;
        debugText('  $choice', columnName);
      }
    });
  }
}
