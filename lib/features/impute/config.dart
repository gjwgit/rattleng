/// Widget to configure the IMPUTE feature of the TRANSFORM tab.
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Wednesday 2024-10-16 10:18:41 +1100 Graham Williams>
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

// TODO 20240811 gjw RE-ENGINEER AS IN CLEANUP

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/spacing.dart';
import 'package:rattle/providers/imputed.dart';
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/providers/selected.dart';
import 'package:rattle/providers/vars/types.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/utils/get_missing.dart';
import 'package:rattle/utils/show_ok.dart';
import 'package:rattle/utils/show_under_construction.dart';
import 'package:rattle/utils/variable_chooser.dart';
import 'package:rattle/widgets/activity_button.dart';
import 'package:rattle/widgets/choice_chip_tip.dart';
import 'package:rattle/widgets/delayed_tooltip.dart';

/// This is a StatefulWidget to pass the REF across to the rSource as well as to
/// monitor the SELECTED variable to transform.
class ImputeConfig extends ConsumerStatefulWidget {
  const ImputeConfig({super.key});

  @override
  ConsumerState<ImputeConfig> createState() => ImputeConfigState();
}

class ImputeConfigState extends ConsumerState<ImputeConfig> {
  String selected = 'NULL';

  // methods enable only for numeric variables.

  List<String> numericMethods = [
    'Mean',
    'Median',
  ];

  // List choice of methods for imputation.

  List<String> methods = [
    'Mean',
    'Median',
    'Mode',
    'Constant',
  ];

  String selectedTransform = 'Mean';

  // Initialize a TextEditingController for the CONSTANT value.

  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.

    _controller.dispose();
    super.dispose();
  }

  // TODO 20240810 gjw USE CHOICE CHIP TIP

  // Transform chooser widget with tooltips for each chip.

  // Widget transformChooser() {
  //   return Align(
  //     // Align the chips to the left.
  //     alignment: Alignment.centerLeft,
  //     child: Wrap(
  //       spacing: 5.0,
  //       runSpacing: choiceChipRowSpace,
  //       children: methods.map((transform) {
  //         bool disableNumericMethods;
  //         if (selected != 'NULL') {
  //           disableNumericMethods = numericMethods.contains(transform) &&
  //               ref.read(typesProvider)[selected] == Type.categoric;
  //         } else {
  //           disableNumericMethods = false;
  //           debugPrint('Error: selected is NULL!!!');
  //         }

  //         return ChoiceChipTip<String>(
  //           options: methods,
  //           selectedOption: selectedTransform,
  //           onSelected: (transform) {
  //             setState(() {
  //               selectedTransform = transform ?? '';
  //               if (selectedTransform == 'Constant') {
  //                 _setConstantDefault();
  //               }
  //             });
  //           },
  //           getLabel: (transform) => transform,
  //           tooltips: const {
  //             'Mean': 'Select Mean for imputation',
  //             'Median': 'Select Median for imputation',
  //             'Mode': 'Select Mode for imputation',
  //             'Constant': 'Select Constant for imputation',
  //           },
  //           enabled: true,
  //         );
  //       }).toList(),
  //     ),
  //   );
  // }

  // Transform chooser widget with tooltips for each chip.

  Widget transformChooser() {
    return Align(
      // Align the chips to the left.
      alignment: Alignment.centerLeft,
      child: ChoiceChipTip<String>(
        options: methods,
        selectedOption: selectedTransform,
        onSelected: (transform) {
          setState(() {
            selectedTransform = transform ?? '';
            if (selectedTransform == 'Constant') {
              _setConstantDefault();
            }
          });
        },
        getLabel: (transform) => transform,
        tooltips: const {
          'Mean': 'Select Mean for imputation',
          'Median': 'Select Median for imputation',
          'Mode': 'Select Mode for imputation',
          'Constant': 'Select Constant for imputation',
        },
        enabled: true,
      ),
    );
  }

  // Set default constant based on variable type.

  void _setConstantDefault() {
    if (ref.read(typesProvider)[selected] == Type.numeric) {
      if (_controller.text.isEmpty) {
        _controller.text = '0';
      }
    } else if (ref.read(typesProvider)[selected] == Type.categoric) {
      if (_controller.text.isEmpty) {
        _controller.text = 'Missing';
      }
    }
  }

  // Constant entry widget with a tooltip.

  Widget constantEntry() {
    return SizedBox(
      width: 150,
      child: DelayedTooltip(
        message: '''
        
        Enter a constant value for the imputation. Typically this might be 0 or
        some sentinel value like 99 for numeric variables, or 'Missing' for a
        categoric variable. This field is only editable when the Constant chip
        is selected.
         
        ''',
        child: TextField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: 'Constant',
            border: OutlineInputBorder(),
          ),
          enabled: selectedTransform == 'Constant',
        ),
      ),
    );
  }

  // BUILD button action.

  void takeAction() {
    // Run the R scripts.

    if (selectedTransform == 'Constant' && ref.read(imputedProvider) == '') {
      showOk(
        context: context,
        title: 'No Constant Value',
        content: '''

            To impute missing data to a constant value for this variable you
            need to specify the constant value. Please provide a Constant and
            try again.

            ''',
      );
    } else {
      switch (selectedTransform) {
        case 'Mean':
          rSource(context, ref, ['transform_impute_mean_numeric']);
        case 'Median':
          rSource(context, ref, ['transform_impute_median_numeric']);
        case 'Mode':
          rSource(context, ref, ['transform_impute_mode']);
        case 'Constant':
          rSource(context, ref, ['transform_impute_constant']);
        default:
          showUnderConstruction(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // this ensures that the new var immedicately appear in the menu.
    // updateRolesProvider(ref);
    // Retireve the list of variables that have missing values as the label and
    // value of the dropdown menu.

    List<String> inputs = getMissing(ref);

    // TODO 20240725 gjw ONLY WANT NUMC VAIABLES AVAILABLE FOR RESCALE

    // Retrieve the current selected variable and use that as the initial value
    // for the dropdown menu. If there is no current value and we do have inputs
    // then we choose the first input variable.

    selected = ref.watch(selectedProvider);
    if (selected == 'NULL' && inputs.isNotEmpty) {
      setState(() {
        selected = inputs.first;
        debugPrint('selected changed to $selected');
      });

      // ref.read(selectedProvider.notifier).state = selected;
    }

    // Retrieve the current imputation constant and use that as the initial
    // value for the text field. If there is no current value then it should be
    // empty.

    String constant = ref.watch(imputedProvider);
    if (constant == 'NULL') {
      constant = '';
    }

    return Column(
      children: [
        configTopSpace,
        Row(
          children: [
            configLeftSpace,
            ActivityButton(
              // Optional navigation.

              pageControllerProvider: imputePageControllerProvider,

              onPressed: () {
                setState(() {
                  constant = _controller.text;
                });
                ref.read(selectedProvider.notifier).state = selected;
                ref.read(imputedProvider.notifier).state = constant;
                debugPrint(constant);
                takeAction();
              },
              child: const Text('Impute Missing Values'),
            ),

            configWidgetSpace,

            // Use local one because of the subtle difference.

            // TODO 20241016 gjw KEVIN PLEASE EXPLAIN THE SUBTLE DIFFERENCE

            variableChooser(
              'Variable',
              inputs,
              selected,
              ref,
              selectedProvider,
              enabled: true,
              // On selection as well as recording what was selected rebuild the
              // visualisations.

              onChanged: (String? value) {
                ref.read(selectedProvider.notifier).state =
                    value ?? 'IMPOSSIBLE';
                selectedTransform = 'Mean';
                // We don't buildAction() here since the variable choice might
                // be followed by a transform choice and we don;t want to shoot
                // off building lots of new variables unnecesarily.
              },
              tooltip: '''

              Select the variable for which missing values will be imputed.

              ''',
            ),

            configWidgetSpace,

            transformChooser(),

            configChooserSpace,

            constantEntry(),
          ],
        ),
      ],
    );
  }
}
