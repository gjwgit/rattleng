/// Dataset display with pages.
//
// Time-stamp: <Monday 2025-03-10 09:34:16 +1100 Graham Williams>
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

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import 'package:rattle/constants/app.dart';
import 'package:rattle/constants/markdown.dart';
import 'package:rattle/constants/spacing.dart';
import 'package:rattle/providers/meta_data.dart';
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/providers/path.dart';
import 'package:rattle/providers/roles_table_rebuild.dart';
import 'package:rattle/providers/selected_row.dart';
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
import 'package:rattle/utils/save_dataset_button.dart';
import 'package:rattle/utils/show_ok.dart';
import 'package:rattle/utils/update_roles_provider.dart';
import 'package:rattle/utils/update_meta_data.dart';
import 'package:rattle/utils/debug_text.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';
import 'package:rattle/widgets/page_viewer.dart';
import 'package:rattle/utils/show_markdown_file_2.dart';
import 'package:rattle/widgets/text_page.dart';

const smallSpace = Gap(10);

/// The dataset panel displays the RattleNG welcome on the first page and the
/// ROLES as the second page.

class DatasetDisplay extends ConsumerStatefulWidget {
  const DatasetDisplay({super.key});

  @override
  ConsumerState<DatasetDisplay> createState() => _DatasetDisplayState();
}

class _DatasetDisplayState extends ConsumerState<DatasetDisplay> {
  // Track pressed keys for shift and control selection.

  bool _isShiftPressed = false;
  bool _isCtrlPressed = false;

  // Define fixed widths for each of the 6 columns.
  // Adjust these as needed for your data and UI.

  static const List<double> columnWidths = <double>[
    100, // Variable
    400, // Role
    40, // Type
    40, // Unique
    40, // Missing
    200, // Sample
  ];

  @override
  Widget build(BuildContext context) {
    final pageController = ref.watch(pageControllerProvider);

    final path = ref.watch(pathProvider);
    final stdout = ref.watch(stdoutProvider);

    // Watch rebuildTriggerProvider to trigger a rebuild when its value changes.

    ref.watch(rebuildTriggerProvider);

    // FIRST PAGE: Welcome Message.

    List<Widget> pages = [
      showMarkdownFile2(welcomeIntroFile1, welcomeIntroFile2, context),
    ];

    // Handle different file types.

    if (path.endsWith('.txt')) {
      _addTextFilePage(stdout, pages);
    } else if (path == weatherDemoFile ||
        // TODO 20250310 gjw Remo the deprecated weatherDemoFile

        path.endsWith('.csv') ||
        path.endsWith('.xlsx')) {
      // 20240815 gjw Update the metaData provider here if needed.

      updateMetaData(ref);

      _addDatasetPage(stdout, pages);
    }

    // Listen for shift/ctrl key events.

    HardwareKeyboard.instance.addHandler((event) {
      setState(() {
        _isShiftPressed = HardwareKeyboard.instance.logicalKeysPressed
                .contains(LogicalKeyboardKey.shiftLeft) ||
            HardwareKeyboard.instance.logicalKeysPressed
                .contains(LogicalKeyboardKey.shiftRight);

        _isCtrlPressed = HardwareKeyboard.instance.logicalKeysPressed
                .contains(LogicalKeyboardKey.controlLeft) ||
            HardwareKeyboard.instance.logicalKeysPressed
                .contains(LogicalKeyboardKey.controlRight);
      });

      return false;
    });

    return PageViewer(
      pageController: pageController,
      pages: pages,
    );
  }

  ////////////////////////////////////////////////////////////////////////

  // Add a page for text file (a .txt file) content.

  void _addTextFilePage(String stdout, List<Widget> pages) {
    String content = rExtract(stdout, '> cat(txt,');
    String title = '''

        # Text Content

        Generated using
        [base::cat(txt)](https://www.rdocumentation.org/packages/base/topics/cat).

        ''';

    if (content.isNotEmpty) {
      pages.add(TextPage(title: title, content: '\n$content'));
    }
  }

  ////////////////////////////////////////////////////////////////////////
  // Add a page for dataset summary.

  void _addDatasetPage(String stdout, List<Widget> pages) {
    final currentRoles = ref.read(rolesProvider);
    final vars = extractVariables(stdout);
    final highVars = extractLargeFactors(stdout);

    _initializeRoles(vars, highVars, currentRoles);

    // When a new row is added after transformation, initialize its role and
    // update the role of the old variable.

    updateVariablesProvider(ref);

    Map<String, String> rolesOption = {
      'Ignore': '''

      For the selected variables in the data table below set their role to
      **Ignore**. Ignored variables will not be used in any analysis and can be
      removed from the dataset using the **Cleanup** feature under the
      **Transform** tab.

      ''',
      'Input': '''

      For the slected variables in the data table below set their role to
      **Input**. Input variables are used for predictive modelling in the
      **Model** tab, for example, to predict a **Target** variable.

      ''',
    };

    // Function to update the role for multiple selected rows.

    void _updateRoleForSelectedRows(String newRole) {
      setState(() {
        final selectedRows = ref.read(selectedRowIndicesProvider);
        final newStdout = ref.watch(stdoutProvider);
        final newVars = extractVariables(newStdout);
        for (var index in selectedRows) {
          String columnName = newVars[index].name;
          ref.read(rolesProvider.notifier).state[columnName] =
              (newRole == 'Ignore') ? Role.ignore : Role.input;
        }
        selectedRows.clear();
        ref.read(rebuildTriggerProvider.notifier).state++;
      });
    }

    // Build the dataset page.

    pages.add(
      Column(
        children: [
          // 1) A Wrap for top row buttons so they won't overlap.

          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              ...rolesOption.keys.map((roleKey) {
                return ElevatedButton(
                  onPressed: () {
                    final selectedRows = ref.read(selectedRowIndicesProvider);
                    if (selectedRows.isEmpty) {
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
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      _updateRoleForSelectedRows(roleKey);
                    }
                  },
                  child: Text(roleKey),
                );
              }).toList(),

              // The Save Dataset button.

              SaveDatasetButton(),

              // The viewer button.

              MarkdownTooltip(
                message: '''

                **Viewer.** Tap here to open a separate window to view the current dataset.
                The default data viewer in R will be used, invoked as `View(ds)`.
                
                ''',
                child: IconButton(
                  icon: const Icon(Icons.table_view, color: Colors.blue),
                  onPressed: () {
                    final p = ref.read(pathProvider);
                    if (p.isEmpty) {
                      showOk(
                        context: context,
                        title: 'No Dataset Loaded',
                        content: '''
                        Please choose a dataset to load from the **Dataset** tab.
                        There is not much we can do until we have loaded a dataset.
                        ''',
                      );
                    } else {
                      rExecute(ref, 'View(ds)\n');
                    }
                  },
                ),
              ),
            ],
          ),

          // 2) The fixed header row.

          SizedBox(
            height: 56.0,
            child: DataTable(
              columns: [
                DataColumn(
                  label: SizedBox(
                    width: columnWidths[0],
                    child: MarkdownTooltip(
                      message: '''

                          To select or deselect all variables shift-click the
                          checkbox to the left here in the header row.
                          
                          ''',
                      child: const Text(
                        'Variable',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                DataColumn(
                  label: SizedBox(
                    width: columnWidths[1],
                    child: const Text(
                      'Role',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                DataColumn(
                  label: SizedBox(
                    width: columnWidths[2],
                    child: const Text(
                      'Type',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                DataColumn(
                  label: SizedBox(
                    width: columnWidths[3],
                    child: const Text(
                      'Unique',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  numeric: true,
                ),
                DataColumn(
                  label: SizedBox(
                    width: columnWidths[4],
                    child: const Text(
                      'Missing',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  numeric: true,
                ),
                DataColumn(
                  label: SizedBox(
                    width: columnWidths[5],
                    child: const Text(
                      'Sample',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
              rows: const [],
            ),
          ),

          // 3) The scrollable body below the header.

          Expanded(
            child: SingleChildScrollView(
              key: const Key('roles listView'),
              scrollDirection: Axis.vertical,
              child: DataTable(
                columns: List.generate(columnWidths.length, (index) {
                  return DataColumn(
                    label: SizedBox(width: columnWidths[index]),
                  );
                }),
                rows: vars.map((variable) {
                  int rowIndex = vars.indexOf(variable);
                  bool isSelected =
                      ref.watch(selectedRowIndicesProvider).contains(rowIndex);
                  final formatter = NumberFormat('#,###');

                  return DataRow(
                    selected: isSelected,
                    onSelectChanged: (bool? selected) {
                      setState(() {
                        if (selected == true) {
                          if (_isShiftPressed) {
                            ref.read(selectedRowIndicesProvider).add(rowIndex);
                          } else if (_isCtrlPressed &&
                              ref.read(selectedRowIndicesProvider).isNotEmpty) {
                            int first =
                                ref.read(selectedRowIndicesProvider).first;
                            int last = rowIndex;
                            if (last < first) {
                              int temp = first;
                              first = last;
                              last = temp;
                            }
                            for (int i = first; i <= last; i++) {
                              ref.read(selectedRowIndicesProvider).add(i);
                            }
                          } else {
                            ref.read(selectedRowIndicesProvider).clear();
                            ref.read(selectedRowIndicesProvider).add(rowIndex);
                          }
                        } else {
                          ref.read(selectedRowIndicesProvider).remove(rowIndex);
                        }
                      });
                    },
                    cells: [
                      DataCell(
                        SizedBox(
                          width: columnWidths[0],
                          child: Text(variable.name),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: columnWidths[1],
                          child: _buildRoleChips(
                            variable.name,
                            ref.watch(rolesProvider),
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: columnWidths[2],
                          child: Text(variable.type),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: columnWidths[3],
                          child: Text(
                            formatter.format(
                              ref.watch(metaDataProvider)[variable.name]
                                      ?['unique']?[0] ??
                                  0,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: columnWidths[4],
                          child: Text(
                            formatter.format(
                              ref.watch(metaDataProvider)[variable.name]
                                      ?['missing']?[0] ??
                                  0,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: columnWidths[5],
                          child: SelectableText(
                            _truncateContent(variable.details),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Initialize roles.

  void _initializeRoles(List<VariableInfo> vars, List<String> highVars,
      Map<String, Role> currentRoles) {
    if (currentRoles.isEmpty && vars.isNotEmpty) {
      for (var column in vars) {
        _setInitialRole(column, ref);
      }
      _setTargetRole(vars, ref);
      _setIdentRole(ref);
    }
  }

  // Set initial role for a variable.

  void _setInitialRole(VariableInfo column, WidgetRef ref) {
    String name = column.name.toLowerCase();
    Role role = Role.input;
    if (name.startsWith('risk_')) role = Role.risk;
    if (name.startsWith('ignore_')) role = Role.ignore;
    if (name.startsWith('target_')) role = Role.target;
    ref.read(rolesProvider.notifier).state[column.name] = role;
    ref.read(typesProvider.notifier).state[column.name] =
        isNumeric(column.type) ? Type.numeric : Type.categoric;
  }

  // By default treat the last variable as TARGET if none is set.

  void _setTargetRole(List<VariableInfo> vars, WidgetRef ref) {
    String target = getTarget(ref);
    if (target == 'NULL') {
      ref.read(rolesProvider.notifier).state[vars.last.name] = Role.target;
    } else if (target != '""') {
      ref.read(rolesProvider.notifier).state[target] = Role.target;
    }
  }

  // Identify ID columns if they have unique values for each row.

  void _setIdentRole(WidgetRef ref) {
    for (var id in getUniqueColumns(ref)) {
      ref.read(rolesProvider.notifier).state[id] = Role.ident;
    }
    final metaData = ref.read(metaDataProvider);
    if (metaData.length == 2) {
      ref.read(rolesProvider.notifier).state[metaData.keys.first] = Role.ident;
      ref.read(rolesProvider.notifier).state[metaData.keys.last] = Role.target;
    }
  }

  // Build role choice chips.

  Widget _buildRoleChips(String columnName, Map<String, Role> currentRoles) {
    return Center(
      key: Key('role-$columnName'),
      child: SizedBox(
        width: choiceChipRowWidth,
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
                  selected, choice, columnName, currentRoles),
            );
          }).toList(),
        ),
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
    setState(() {
      if (selected) {
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
    const maxLength = 45;
    String subStr =
        content.length > maxLength ? content.substring(0, maxLength) : content;
    int lastCommaIndex = subStr.lastIndexOf(',') + 1;
    return '${lastCommaIndex > 0 ? content.substring(0, lastCommaIndex) : subStr} ...';
  }
}
