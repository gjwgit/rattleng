/// Widget to configure the CLEANUP feature of the TRANSFORM tab.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Thursday 2025-03-20 16:52:31 +1100 Graham Williams>
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
/// Authors: Graham Williams, Yixiang Yin, Kevin Wang

library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';

import 'package:rattle/constants/spacing.dart';
import 'package:rattle/providers/cleanup_method.dart';
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/providers/selected.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/utils/debug_text.dart';
import 'package:rattle/utils/get_ignored.dart';
import 'package:rattle/utils/get_inputs_and_ignore_transformed.dart';
import 'package:rattle/utils/get_missing.dart';
import 'package:rattle/utils/get_obs_missing.dart';
import 'package:rattle/utils/get_target.dart';
import 'package:rattle/utils/show_ok.dart';
import 'package:rattle/utils/show_under_construction.dart';
import 'package:rattle/utils/target_missing_values.dart';
import 'package:rattle/utils/update_roles_provider.dart';
import 'package:rattle/utils/variable_chooser.dart';
import 'package:rattle/widgets/activity_button.dart';
import 'package:rattle/widgets/choice_chip_tip.dart';

/// This is a StatefulWidget to pass the ref across to the rSource.

class CleanupConfig extends ConsumerStatefulWidget {
  const CleanupConfig({super.key});

  @override
  ConsumerState<CleanupConfig> createState() => CleanupConfigState();
}

class CleanupConfigState extends ConsumerState<CleanupConfig> {
  // List choice of methods for cleanup and their tooltips.

  Map<String, String> multiMethods = {
    'Vars with Missing': '''

      **Vars with Missong:** Choose this chip to remove from the dataset all
      columns (variables) that have any missing values. The variables with
      missing values are indicated in the data summary and they will be
      identified before removal through a popup, so you have a chance to review
      them before committing to do so.

      ''',
    'Obs with Missing': '''

      **Obs with Missing:** Choose this chip to remove from the dataset all rows
      (observations) that have any missing values.

      ''',
    'Obs with Missing Target': '''

      **Obs with Missing Target:** Choose this chip to remove from the dataset target 
      row that have any missing values. The chip will be disabled if the target is not 
      set or has no missing observations.

      ''',
    'Ignored': '''

      **Ignored:** Choose this chip to remove from the dataset all columns
      (variables) from the dataset that are marked as **Ignore* in the
      **Dataset** tab's **Role** page. The variables to be removed will be
      identified through a popup and you will have a chance to review them
      before comitting to do so.

      ''',
  };

  Map<String, String> specificMethods = {
    'Variable': '''

      **Variable:** Choose this chip to remove the selected variable from the
      dataset. Be sure to select a variable from the **Variable** drop down
      menu. You can only remove one variable at a time. To remove multiple
      variables, select to **Ignore** them in the **Dataset** tab's **Role**
      page and then choose the **Delete from Dataset** with the **Ignored** chip
      selected.

      ''',
  };

  RegExp squares = RegExp(r'[\[\]]');

  String warning(method) {
    return switch (method) {
      'Ignored' => '''

        The following variables will be deleted:
        ${getIgnored(ref).toString().replaceAll(squares, "")}.
        Continue?

          ''',
      'Variable' => '''

        The variable ${ref.read(selectedProvider)} will be deleted. Continue?

        ''',
      'Vars with Missing' => '''

        The following ${getMissing(ref).length} variables will be deleted:
        ${getMissing(ref).toString().replaceAll(squares, "")}.  Continue?

        ''',
      'Obs with Missing' => '''

        There are ${getObsMissing(ref)} rows with missing values that will be
        deleted. Continue?

        ''',
      'Obs with Missing Target' => '''

        The target ${getTarget(ref)} row with missing values that will be
        deleted. Continue?

        ''',
      _ => '''

        This shouldn't happen in warningText

        ''',
    };
  }

  String dispatch(method) {
    return switch (method) {
      'Ignored' => 'transform_clean_delete_ignored',
      'Variable' => 'transform_clean_delete_selected',
      'Vars with Missing' => 'transform_clean_delete_vars_missing',
      'Obs with Missing' => 'transform_clean_delete_obs_missing',
      'Obs with Missing Target' => 'transform_clean_delete_obs_missing_target',
      _ => '',
    };
  }

  void deletionAction(String method) {
    // cleanup the state after deletion
    List<String> varsToDelete = [];
    switch (method) {
      case 'Ignored':
        varsToDelete.addAll(getIgnored(ref));
      // two ways to update: read it from the stdout glimpse or update it with the information
      // choose 2
      case 'Variable':
        String select = ref.read(selectedProvider);
        varsToDelete.add(select);
      case 'Vars with Missing':
        varsToDelete.addAll(getMissing(ref));
      case 'Obs with Missing':
        // variables won't be deleted so return directly.

        return;
      case 'Obs with Missing Target':
        // variables won't be deleted so return directly.

        return;
      default:
        showUnderConstruction(context);
    }
    for (var v in varsToDelete) {
      if (deleteVar(ref, v)) {
        debugText('  DELETED', v);
      }
    }
  }

  void takeAction(method) {
    // Run the R scripts.  For different selected cleanup, the text will be
    // different as well as the script to execute.

    // For check special conditions:

    // Delete Ignored but no variables Ignored.

    if (method == 'Ignored' && getIgnored(ref).isEmpty) {
      showOk(
        context: context,
        title: 'No Variables Selected to Ignore',
        content: '''

            To delete the Ignored variables you will first need to choose some
            variables to Ignore from the **Dataset** tab **Roles** page.

            ''',
      );
    } else

    // All good.

    {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.question_mark, color: Colors.green),
                SizedBox(width: 20),
                Text('Confirmation'),
              ],
            ),
            content: Text(wordWrap(warning(method))),
            actions: <Widget>[
              // No button
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              // Yes button
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Yes'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  // has to use await here because if deletion happens before rsource, rsource won't delete anything in R.
                  await rSource(context, ref, [dispatch(method)]);

                  deletionAction(method);
                  ref.read(cleanupPageControllerProvider).animateToPage(
                        // Index of the second page.
                        1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO 20240809 yyx THE DISPLAY NOT UPDATED AFTER CLEANUP

    // Retireve the list of inputs as the label and value of the dropdown menu.

    // TODO 20240807 yyx WHAT SHOULD WE ALLOW TO BE DELETED?

    List<String> inputs = getInputsAndIgnoreTransformed(ref);

    String method = ref.read(cleanUpMethodProvider.notifier).state;

    // Retrieve the current selected variable and use that as the initial value
    // for the dropdown menu. If there is no current value and we do have inputs
    // then we choose the first input variable.

    // TODO 20240807 yyx AFTER DELETION SHOW OTHER VARIABLES NOT DELETED ONE?

    String selected = ref.watch(selectedProvider);

    if (selected == 'NULL' && inputs.isNotEmpty) {
      selected = inputs.first;
    }

    return Column(
      spacing: configRowSpace,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: configWidgetSpace,
            children: [
              ActivityButton(
                onPressed: () {
                  ref.read(selectedProvider.notifier).state = selected;
                  takeAction(method);
                },
                child: const Text('Delete from Dataset'),
              ),

              ChoiceChipTip<String>(
                options: multiMethods.keys.toList(),
                selectedOption: method,
                tooltips: multiMethods,
                onSelected: (chosen) {
                  setState(() {
                    if (chosen != null) {
                      method = chosen;
                      ref.read(cleanUpMethodProvider.notifier).state = chosen;
                    }
                  });
                },
                // Check if the target variable has missing values.
                // The check only applies to the "Obs with Missing Target" option.

                isOptionDisabled: (option) =>
                    option == multiMethods.keys.toList()[2] &&
                    !hasTargetMissingValues(ref),
              ),

              ChoiceChipTip<String>(
                options: specificMethods.keys.toList(),
                selectedOption: method,
                tooltips: specificMethods,
                onSelected: (chosen) {
                  setState(() {
                    if (chosen != null) {
                      method = chosen;
                      ref.read(cleanUpMethodProvider.notifier).state = chosen;
                    }
                  });
                },
              ),

              // Use the variableChooser with enabled parameter.

              variableChooser(
                'Variable',
                inputs,
                selected,
                ref,
                selectedProvider,
                tooltip: '''

                Select the variable to be deleted from the dataset.
                ${method != 'Variable' ? 'Choose the Variable chip to enable this option.' : ''}

                ''',
                // Enable only when method is 'Variable'.
                enabled: method == 'Variable',
                onChanged: (value) {
                  if (value != null && method != 'Variable') {
                    setState(() {
                      method = 'Variable';
                      ref.read(cleanUpMethodProvider.notifier).state =
                          'Variable';
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
