/// Widget to configure the RESCALE feature of the TRANSFORM tab.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Wednesday 2024-10-16 13:32:55 +1100 Graham Williams>
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
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/spacing.dart';
import 'package:rattle/providers/interval.dart';
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/providers/selected.dart';
import 'package:rattle/providers/vars/types.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/utils/get_inputs.dart';
import 'package:rattle/utils/show_under_construction.dart';
import 'package:rattle/utils/update_roles_provider.dart';
import 'package:rattle/utils/variable_chooser.dart';
import 'package:rattle/widgets/activity_button.dart';
import 'package:rattle/widgets/choice_chip_tip.dart';
import 'package:rattle/widgets/number_field.dart';

/// This is a StatefulWidget to pass the ref across to the rSource
/// monitor the selected variable.

class RescaleConfig extends ConsumerStatefulWidget {
  const RescaleConfig({super.key});

  @override
  ConsumerState<RescaleConfig> createState() => RescaleConfigState();
}

class RescaleConfigState extends ConsumerState<RescaleConfig> {
  // List choice of methods for rescaling.

  List<String> normaliseMethods = [
    'Recenter',
    'Scale [0-1]',
    '-Median/MAD',
    'Natural Log',
    'Log 10',
  ];

  List<String> orderMethods = [
    'Rank',
    'Interval',
  ];

  // Define tooltips for normaliseMethods.

  Map<String, String> normaliseMethodTooltips = {
    'Recenter': '''

    Recenter the values of the variable around zero by subtracting the mean and
    dividing by the root-mean-square. The resulting values will have a mean of
    zero and a spread of positive and negative numbers around 0.

    ''',
    'Scale [0-1]': '''

    Rescale the values of the variable to be in the range between 0 and 1.

    ''',
    '-Median/MAD': '''

    Similar to the Recenter operation, this will subtract the median (instead of
    the mean) and and divide by the median absolute deviation. This is
    considered to be a more robust transformation.

    ''',
    'Natural Log': '''

    Apply the natural logarithm to the values of the variable.

    ''',
    'Log 10': '''

    Apply the base 10 logarithm to the values of the variable.

    ''',
  };

  // Define tooltips for orderMethods.

  Map<String, String> orderMethodTooltips = {
    'Rank': '''

    Rescale based on the rank order of the values of the variable so the values
    start from 1 up to the number of different values for the variable..

    ''',
    'Interval': '''

    Rescale within the specified interval range.

    ''',
  };

  String selectedTransform = 'Recenter';

  Widget rescaleChooser() {
    final TextEditingController valCtrl = TextEditingController();
    valCtrl.text = ref.read(intervalProvider.notifier).state.toString();

    return Row(
      children: [
        // Add tooltips to normaliseMethods ChoiceChipTip.

        ChoiceChipTip<String>(
          options: normaliseMethods,
          selectedOption: selectedTransform,
          onSelected: (String? selected) {
            setState(() {
              selectedTransform = selected ?? '';
            });
          },
          // Adding tooltips here.

          tooltips: normaliseMethodTooltips,
        ),
        configWidgetGap,
        // Add tooltips to orderMethods ChoiceChipTip.

        ChoiceChipTip<String>(
          options: orderMethods,
          selectedOption: selectedTransform,
          onSelected: (String? selected) {
            setState(() {
              selectedTransform = selected ?? '';
            });
          },
          // Adding tooltips here.

          tooltips: orderMethodTooltips,
        ),
        configWidgetGap,
        NumberField(
          label: 'Interval',
          tooltip: '''

          When rescaling a numeric variable using an Interval, the numeric value
          here is the maximum value for the resulting interval. A default
          maximum value of 100 is often used. The minimum value is fixed as 0.

          ''',
          controller: valCtrl,

          // Allow integers only.

          inputFormatter: FilteringTextInputFormatter.digitsOnly,
          validator: (value) => validateInteger(value, min: 1),
          stateProvider: intervalProvider,

          // Enable only when "Interval" is selected.

          enabled: selectedTransform == 'Interval',
        ),
      ],
    );
  }

  // BUILD button action.

  void buildAction() {
    // Run the R scripts.

    switch (selectedTransform) {
      case 'Recenter':
        rSource(context, ref, ['transform_rescale_recenter_numeric']);
      case 'Scale [0-1]':
        rSource(context, ref, ['transform_rescale_scale01_numeric']);
      case '-Median/MAD':
        rSource(context, ref, ['transform_rescale_medmad_numeric']);
      case 'Natural Log':
        rSource(context, ref, ['transform_rescale_natlog_numeric']);
      case 'Log 10':
        rSource(context, ref, ['transform_rescale_log10_numeric']);
      case 'Rank':
        rSource(context, ref, ['transform_rescale_rank']);
      case 'Interval':
        // debugPrint('run interval');
        rSource(context, ref, ['transform_rescale_interval']);
      default:
        showUnderConstruction(context);
    }
    // Notice that rSource is asynchronous so this glimpse is oftwn happening
    // before the above transformation.
    //
    // rSource(context, ref, ['glimpse']);
  }

  @override
  Widget build(BuildContext context) {
    // This ensures that the new var immedicately appear in the menu.

    updateVariablesProvider(ref);

    // Variables that were automatically ignored through a transform should
    // still be listed in the TRANSFORM selected list because I might want to do
    // some more transforms on it.  Variables the user has marked as IGNORE
    // should not be listed in the TRANSFORM tab.

    // Retireve the list of numeric inputs as the label and value of the
    // dropdown menu.

    List<String> inputs = getInputsAndIgnoreTransformed(ref);
    List<String> numericInputs = [];
    // We want to refresh the options if there are any new variables added so
    // we use a watch here.
    Map<String, Type> types = ref.watch(
      // TODO 20241011 gjw MIGRATE TO USING metaData INSTEAD OF types.
      typesProvider,
    );
    for (var i in inputs) {
      if (types[i] == Type.numeric) {
        numericInputs.add(i);
      }
    }
    // Retrieve the current selected variable and use that as the initial value
    // for the dropdown menu. If there is no current value and we do have inputs
    // then we choose the first input variable.

    String selected = ref.watch(selectedProvider);
    if (selected == 'NULL' && numericInputs.isNotEmpty) {
      selected = numericInputs.first;
    }

    return Column(
      children: [
        configTopGap,
        Row(
          children: [
            configLeftGap,
            ActivityButton(
              tooltip: '''

              Tap here to perform the chosen rescale operation on the selected
              variable. Once the transform has completed the second page will
              show a summary of the new dartaset.

              ''',
              onPressed: () {
                ref.read(selectedProvider.notifier).state = selected;
                buildAction();
                ref.read(rescalePageControllerProvider).animateToPage(
                      // Index of the second page.
                      1,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
              },
              child: const Text('Rescale Variable Values'),
            ),
            configWidgetGap,
            variableChooser(
              'Variable',
              numericInputs,
              selected,
              ref,
              selectedProvider,
              tooltip: '''

              Select the variable to be rescaled. Only numeric variables are
              listed here. Once a variable has been rescaled it will become an
              ignored variable. It remains listed here together with the newly
              created transformed variable as we may want to do multiple
              transforms on the same variable.

              ''',
              // Enable only if there are numeric inputs.
              enabled: numericInputs.isNotEmpty,
              onChanged: (value) {
                if (value != null) {
                  ref.read(selectedProvider.notifier).state = value;
                }
              },
            ),
          ],
        ),
        rescaleChooser(),
      ],
    );
  }
}
