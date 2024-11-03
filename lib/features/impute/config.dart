/// A widget to configure the IMPUTE feature of the TRANSFORM tab.
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Thursday 2024-10-17 12:07:50 +1100 Graham Williams>
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

/// A [StatefulWidget] (rather than [Stateless]) to pass `ref` across to
/// `rSource()` as well as to monitor the SELECTED variable to transform.

class ImputeConfig extends ConsumerStatefulWidget {
  const ImputeConfig({super.key});

  @override
  ConsumerState<ImputeConfig> createState() => ImputeConfigState();
}

class ImputeConfigState extends ConsumerState<ImputeConfig> {
  String selected = 'NULL';

  // List of transformations enabled only for numeric variables.

  List<String> numericMethods = [
    'Mean',
    'Median',
  ];

  // List of all transformations available.

  List<String> methods = [
    'Mean',
    'Median',
    'Mode',
    'Constant',
  ];

  // Default transformation.

  String selectedTransform = 'Mean';

  // Initialize a TextEditingController for the CONSTANT value.

  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.

    _controller.dispose();
    super.dispose();
  }

  // Define a transform chooser widget with tooltips for each chip.

  Widget transformChooser() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 5.0,
        runSpacing: choiceChipRowSpace,
        children: [
          // Layout the first group of chips (up to MODE) so we can introduce a
          // gap before CONSTANT and so tie the CONSTANT chip to the CONSTANT
          // field for improved UX.

          ChoiceChipTip<String>(
            options: methods.sublist(0, 3),
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
              'Mean': '''

              Use the mean (average) value of the numeric values of the variable
              as the value imputed for any missing values. Using the mean is
              often useful in maintaining the distribution of values for the
              variable.

              ''',
              'Median': '''

              Use the median (central) value of the numeric values of the
              variable as the value imputed for any missing values. Using the
              median is motivaed as the central value that is less affected by
              outliers in a skewed distribution.

              ''',
              'Mode': '''

              Use the mode (most common) value of the variable values as the
              value imputed for any missing values. Using the mode makes sense
              when the most common value is the logical choice for missing
              values.

              ''',
            },
            enabled: true,
          ),

          // Add extra space between MODE and CONSTANT.

          configChooserGap,

          // Second group of chips (only CONSTANT for now).

          ChoiceChipTip<String>(
            options: methods.sublist(3),
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
              'Constant': '''

              Choose a constant value for the imputation. Specify the value in
              the adjacent Constant field. Typically use 0 for numeric data, if
              appropriate, or 'Missing' for categoric data.

              ''',
            },
            enabled: true,
          ),
        ],
      ),
    );
  }

  // Set the default CONSTANT value based on the variable type.

  void _setConstantDefault() {
    if (ref.read(typesProvider)[selected] == Type.numeric) {
      _controller.text = '0';
    } else if (ref.read(typesProvider)[selected] == Type.categoric) {
      _controller.text = 'Missing';
    }
  }

  // Define a CONSTANT entry widget with a tooltip.

  Widget constantEntry() {
    return SizedBox(
      width: 150,
      child: DelayedTooltip(
        message: '''
        
        Enter a constant value for the imputation. Typically this might be 0 or
        some sentinel value like 99 for numeric variables, if appropriate, or
        'Missing' for a categoric variable. This field is only editable when the
        Constant chip is selected.
         
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

  // Define the BUILD button action.

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
    // for the dropdown menu. If there is no current value and we do have
    // variables with role INPUT then we choose the first INPUT variable.

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

    // Now build and return the configuration widget.

    return Column(
      children: [
        configTopGap,
        Row(
          children: [
            configLeftGap,
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
            configWidgetGap,
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
              },
              tooltip: '''

              Select the variable for which missing values will be imputed. All
              variables having a role of INPUT are available for imputation.

              ''',
            ),
            configWidgetGap,
            transformChooser(),
            configChooserGap,
            constantEntry(),
          ],
        ),
      ],
    );
  }
}
