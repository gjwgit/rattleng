/// Widget to configure the SVM tab: button.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Sunday 2024-08-04 07:46:33 +1000 Graham Williams>
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
/// Authors: Graham Williams

library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rattle/constants/spacing.dart';
import 'package:rattle/providers/number.dart';
import 'package:rattle/providers/selected.dart';
import 'package:rattle/utils/get_inputs.dart';

import 'package:rattle/utils/show_under_construction.dart';
import 'package:rattle/utils/variable_chooser.dart';
import 'package:rattle/widgets/activity_button.dart';
import 'package:rattle/widgets/custom_choice_chip.dart';
import 'package:rattle/widgets/number_field.dart';

/// The SVM tab config currently consists of just an ACTIVITY button.
///
/// This is a StatefulWidget to pass the ref across to the rSource.

class RecodeConfig extends ConsumerStatefulWidget {
  const RecodeConfig({super.key});

  @override
  ConsumerState<RecodeConfig> createState() => RecodeConfigState();
}

class RecodeConfigState extends ConsumerState<RecodeConfig> {
  String selectedTransform = 'Quantiles';

  List<String> numericMethods = [
    'Quantiles',
    'KMeans',
    'Equal Width',
  ];

  List<String> categoricMethods = [
    'Quantiles',
    'KMeans',
    'Equal Width',
  ];

  Widget recodeChooser() {
    final TextEditingController valCtrl = TextEditingController();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Wrap(
          spacing: 5.0,
          children: numericMethods.map((transform) {
            return CustomChoiceChip(
              label: transform,
              selectedTransform: selectedTransform,
              onSelected: (bool selected) {
                setState(() {
                  selectedTransform = selected ? transform : '';
                });
              },
            );
          }).toList(),
        ),
        configWidgetSpace,
        NumberField(
          label: 'Number',
          controller: valCtrl,
          stateProvider: numberProvider,
          validator: (value) => validateInteger(value, min: 1),
          inputFormatter: FilteringTextInputFormatter.digitsOnly,
        ),
        configWidgetSpace,
        Wrap(
          spacing: 5.0,
          children: categoricMethods.map((transform) {
            return CustomChoiceChip(
              label: transform,
              selectedTransform: selectedTransform,
              onSelected: (bool selected) {
                setState(() {
                  selectedTransform = selected ? transform : '';
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> inputs = getInputsAndIgnoreTransformed(ref);
    String selected = ref.watch(selectedProvider);
    if (selected == 'NULL' && inputs.isNotEmpty) {
      selected = inputs.first;
    }

    return Column(
      children: [
        // Space above the beginning of the configs.

        const SizedBox(height: 5),

        Row(
          children: [
            // Space to the left of the configs.

            const SizedBox(width: 5),

            // The BUILD button.

            ActivityButton(
              onPressed: () {
                showUnderConstruction(context);
              },
              child: const Text("Recode Variable's Values"),
            ),
            configWidgetSpace,
            variableChooser(inputs, selected, ref),
          ],
        ),
        recodeChooser(),
      ],
    );
  }
}
