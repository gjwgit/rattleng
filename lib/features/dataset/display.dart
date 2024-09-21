/// Dataset display with pages.
//
// Time-stamp: <Thursday 2024-09-12 16:47:47 +1000 Graham Williams>
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
/// Authors: Graham Williams, Yixiang Yin， Bo Zhang

library;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/app.dart';
import 'package:rattle/constants/spacing.dart';
import 'package:rattle/providers/path.dart';
import 'package:rattle/providers/vars/roles.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/providers/vars/types.dart';
import 'package:rattle/r/extract.dart';
import 'package:rattle/r/extract_large_factors.dart';
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

  // Constants for layout

  final Widget space = const SizedBox(width: 10);

  final int typeFlex = 4;
  final int contentFlex = 3;

  @override
  Widget build(BuildContext context) {

    final String path = ref.watch(pathProvider);
    final String stdout = ref.watch(stdoutProvider);

    List<Widget> pages = [showMarkdownFile(welcomeMsgFile, context)];

    // Handle different file types

    if (path.endsWith('.txt')) {
      _addTextFilePage(stdout, pages);
    } else if (path == weatherDemoFile || path.endsWith('.csv')) {
      _addDatasetPage(stdout, pages);
    }

    return Pages(children: pages);
  }

  // Add a page for text file content
  
  void _addTextFilePage(String stdout, List<Widget> pages) {
    String content = rExtract(stdout, '> cat(ds,');
    String title =
        '# Text Content\n\nGenerated using [base::cat(ds)](https://www.rdocumentation.org/packages/base/topics/cat).';

    if (content.isNotEmpty) {
      pages.add(TextPage(title: title, content: '\n$content'));
    }
  }

  // Add a page for dataset summary

  void _addDatasetPage(String stdout, List<Widget> pages) {
    Map<String, Role> currentRoles = ref.read(rolesProvider);
    List<VariableInfo> vars = extractVariables(stdout);
    List<String> highVars = extractLargeFactors(stdout);

    _initializeRoles(vars, highVars, currentRoles);
    updateVariablesProvider(ref);

    pages.add(
      ListView.builder(
        key: const Key('roles listView'),
        itemCount: vars.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildHeadline();
          } else {
            return _buildDataLine(vars[index - 1], currentRoles);
          }
        },
      ),
    );
  }

  // Initialize roles for variables

  void _initializeRoles(List<VariableInfo> vars, List<String> highVars,
      Map<String, Role> currentRoles,) {
    if (currentRoles.isEmpty && vars.isNotEmpty) {
      for (var column in vars) {
        _setInitialRole(column, ref);
      }
      _setTargetRole(vars, ref);
      _setIdentRole(ref);
      _setIgnoreRoleForHighVars(highVars, ref);
    }
  }

  // Set initial role for a variable

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

  // Set target role

  void _setTargetRole(List<VariableInfo> vars, WidgetRef ref) {
    String target = getTarget(ref);
    if (target == 'NULL') {
      ref.read(rolesProvider.notifier).state[vars.last.name] = Role.target;
    } else {
      ref.read(rolesProvider.notifier).state[target] = Role.target;
    }
  }

  // Set identifier role

  void _setIdentRole(WidgetRef ref) {
    for (var id in getUniqueColumns(ref)) {
      ref.read(rolesProvider.notifier).state[id] = Role.ident;
    }
  }

  // Set ignore role for high cardinality variables

  void _setIgnoreRoleForHighVars(List<String> highVars, WidgetRef ref) {
    for (var highVar in highVars) {
      if (ref.read(rolesProvider.notifier).state[highVar] != Role.target) {
        ref.read(rolesProvider.notifier).state[highVar] = Role.ignore;
      }
    }
  }

  // Build headline for the dataset summary
  
  Widget _buildHeadline() {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(
              child: Text('Variable',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,),),
          space,
          const Expanded(
              child: Text('Type',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,),),
          Expanded(
              flex: typeFlex,
              child: const Text('Role',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,),),
          space,
          Expanded(
              flex: contentFlex,
              child: const Text('Content',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,),),
        ],
      ),
    );
  }

  // Build data line for each variable
  Widget _buildDataLine(VariableInfo variable, Map<String, Role> currentRoles) {
    String content = _truncateContent(variable.details);

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildFittedText(variable.name)),
              space,
              Expanded(child: Text(variable.type)),
              Expanded(
                  flex: typeFlex,
                  child: _buildRoleChips(variable.name, currentRoles),),
              Expanded(
                  flex: contentFlex,
                  child: Text(content, style: const TextStyle(fontSize: 14)),),
            ],
          );
        },
      ),
    );
  }

  // Build fitted text for variable name
  Widget _buildFittedText(String text) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: defaultTextStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.left,
      ),
    );
  }

  // Build role choice chips
  Widget _buildRoleChips(String columnName, Map<String, Role> currentRoles) {
    return Wrap(
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
          onSelected: (bool selected) =>
              _handleRoleSelection(selected, choice, columnName, currentRoles),
        );
      }).toList(),
    );
  }

  // Handle role selection
  void _handleRoleSelection(bool selected, Role choice, String columnName,
      Map<String, Role> currentRoles,) {
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

  // Truncate content for display
  String _truncateContent(String content) {
    int maxLength = 40;
    String subStr =
        content.length > maxLength ? content.substring(0, maxLength) : content;
    int lastCommaIndex = subStr.lastIndexOf(',') + 1;
    return '${lastCommaIndex > 0
            ? content.substring(0, lastCommaIndex)
            : subStr} ...';
  }
}
