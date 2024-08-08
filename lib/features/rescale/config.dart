/// Widget to configure the RESCALE feature of the TRANSFORM tab.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Thursday 2024-08-08 12:12:29 +1000 Graham Williams>
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
import 'package:rattle/r/source.dart';
import 'package:rattle/utils/get_inputs.dart';
import 'package:rattle/utils/show_under_construction.dart';
import 'package:rattle/utils/update_roles_provider.dart';
import 'package:rattle/widgets/activity_button.dart';
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

  Widget variableChooser(List<String> inputs, String selected) {
    return DropdownMenu(
      label: const Text('Variable'),
      width: 200,
      initialSelection: selected,
      dropdownMenuEntries: inputs.map((s) {
        return DropdownMenuEntry(value: s, label: s);
      }).toList(),
      // On selection as well as recording what was selected rebuild the
      // visualisations.
      onSelected: (String? value) {
        ref.read(selectedProvider.notifier).state = value ?? 'IMPOSSIBLE';
        // We don't buildAction() here since the variable choice might
        // be followed by a transform choice and we don;t want to shoot
        // off building lots of new variables unnecesarily.
      },
    );
  }

  // Refine the ChipChoice widget as used across the two rows for this config.

  Widget myChoiceChip(transform) {
    return ChoiceChip(
      label: Text(transform),
      disabledColor: Colors.grey,
      selectedColor: Colors.lightBlue[200],
      backgroundColor: Colors.lightBlue[50],
      shadowColor: Colors.grey,
      pressElevation: 8.0,
      elevation: 2.0,
      selected: selectedTransform == transform,
      onSelected: (bool selected) {
        setState(() {
          selectedTransform = selected ? transform : '';
        });
      },
    );
  }

  Widget normaliseChooser() {
    return Expanded(
      child: Wrap(
        spacing: 5.0,
        children: normaliseMethods.map((transform) {
          return myChoiceChip(transform);
        }).toList(),
      ),
    );
  }

  Widget orderChooser() {
    final TextEditingController valCtrl = TextEditingController();
    valCtrl.text = ref.read(intervalProvider.notifier).state.toString();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Wrap(
          spacing: 5.0,
          children: orderMethods.map((transform) {
            return myChoiceChip(transform);
          }).toList(),
        ),
        configWidgetSpace,
        NumberField(
          label: 'Interval',
          controller: valCtrl,
          enabled: true,
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
    // this ensures that the new var immedicately appear in the menu.
    updateVariablesProvider(ref);

    // Variables that were automatically ignored through a transform should still be listed in the TRANSFORM selected list because I might want to do some more transforms on it.
    // Variables the user has marked as IGNORE should not be listed in the TRANSFORM tab.

    // Retireve the list of inputs as the label and value of the dropdown menu.

    List<String> inputs = getInputsAndIgnoreTransformed(ref);

    // TODO 20240725 gjw ONLY WANT NUMC VAIABLES AVAILABLE FOR RESCALE

    // Retrieve the current selected variable and use that as the initial value
    // for the dropdown menu. If there is no current value and we do have inputs
    // then we choose the first input variable.

    String selected = ref.watch(selectedProvider);
    if (selected == 'NULL' && inputs.isNotEmpty) {
      selected = inputs.first;
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
              child: const Text("Rescale Variable's Values"),
            ),
            configWidgetSpace,
            variableChooser(inputs, selected),
            configWidgetSpace,
            normaliseChooser(),
          ],
        ),
        configTopSpace,
        orderChooser(),
      ],
    );
  }
}
