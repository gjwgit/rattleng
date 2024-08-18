/// Widget to configure the RESCALE feature of the TRANSFORM tab.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Tuesday 2024-08-13 20:00:12 +1000 Graham Williams>
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/spacing.dart';
import 'package:rattle/providers/interval.dart';
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

/// This is a StatefulWidget to pass the ref across to the rSource as well as to
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

  String selectedTransform = 'Recenter';

  Widget rescaleChooser() {
    final TextEditingController valCtrl = TextEditingController();
    valCtrl.text = ref.read(intervalProvider.notifier).state.toString();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ChoiceChipTip<String>(
          options: normaliseMethods,
          selectedOption: selectedTransform,
          onSelected: (String? selected) {
            setState(() {
              selectedTransform = selected ?? '';
            });
          },
        ),
        configWidgetSpace,
        ChoiceChipTip<String>(
          options: orderMethods,
          selectedOption: selectedTransform,
          onSelected: (String? selected) {
            setState(() {
              selectedTransform = selected ?? '';
            });
          },
        ),
        configWidgetSpace,
        NumberField(
          label: 'Interval',
          controller: valCtrl,
          inputFormatter:
              FilteringTextInputFormatter.digitsOnly, // Integers only
          validator: (value) => validateInteger(value, min: 1),
          stateProvider: intervalProvider,
        ),
      ],
    );
  }

  // BUILD button action.

  void buildAction() {
    // Run the R scripts.

    switch (selectedTransform) {
      case 'Recenter':
        rSource(context, ref, 'transform_rescale_recenter_numeric');
      case 'Scale [0-1]':
        rSource(context, ref, 'transform_rescale_scale01_numeric');
      case '-Median/MAD':
        rSource(context, ref, 'transform_rescale_medmad_numeric');
      case 'Natural Log':
        rSource(context, ref, 'transform_rescale_natlog_numeric');
      case 'Log 10':
        rSource(context, ref, 'transform_rescale_log10_numeric');
      case 'Rank':
        rSource(context, ref, 'transform_rescale_rank');
      case 'Interval':
        // debugPrint('run interval');
        rSource(context, ref, 'transform_rescale_interval');
      default:
        showUnderConstruction(context);
    }
    // Notice that rSource is asynchronous so this glimpse is oftwn happening
    // before the above transformation.
    //
    // rSource(context, ref, 'glimpse');
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
    Map<String, Type> types = ref.watch(
      typesProvider,
    ); // want to refresh the options if there is new variables added so use watch
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
        configTopSpace,
        Row(
          children: [
            configLeftSpace,
            ActivityButton(
              onPressed: () {
                ref.read(selectedProvider.notifier).state = selected;
                buildAction();
              },
              child: const Text('Rescale Variable Values'),
            ),
            configWidgetSpace,
            variableChooser(
                'Variable', numericInputs, selected, ref, selectedProvider, ),
          ],
        ),
        rescaleChooser(),
      ],
    );
  }
}
