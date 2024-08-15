/// Widget to configure the IMPUTE feature of the TRANSFORM tab.
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Wednesday 2024-08-14 05:45:31 +1000 Graham Williams>
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
import 'package:rattle/providers/selected.dart';
import 'package:rattle/providers/vars/types.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/utils/get_missing.dart';
import 'package:rattle/utils/show_ok.dart';
import 'package:rattle/utils/show_under_construction.dart';
import 'package:rattle/widgets/activity_button.dart';

/// This is a StatefulWidget to pass the REF across to the rSource as well as to
/// monitor the SELECTED variable to transform.

class ImputeConfig extends ConsumerStatefulWidget {
  const ImputeConfig({super.key});

  @override
  ConsumerState<ImputeConfig> createState() => ImputeConfigState();
}

class ImputeConfigState extends ConsumerState<ImputeConfig> {
  String selected = 'NULL';

  // methods enable only for numeric variables
  List<String> numericMethods = [
    'Mean',
    'Median',
  ];
  // List choice of methods for imputation.

  List<String> methods = [
    'Zero/Missing',
    'Mean',
    'Median',
    'Mode',
    'Constant',
  ];

  String selectedTransform = 'Zero/Missing';

  Widget variableChooser(List<String> inputs, String selected, WidgetRef ref) {
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
        selectedTransform = 'Zero/Missing';
        // We don't buildAction() here since the variable choice might
        // be followed by a transform choice and we don;t want to shoot
        // off building lots of new variables unnecesarily.
      },
    );
  }

  // TODO 20240810 gjw USE CHOICE CHIP TIP

  Widget transformChooser() {
    return Expanded(
      child: Wrap(
        spacing: 5.0,
        runSpacing: choiceChipRowSpace,
        children: methods.map((transform) {
          bool disableNumericMethods;
          if (selected != 'NULL') {
            disableNumericMethods = numericMethods.contains(transform) &&
                ref.read(typesProvider)[selected] == Type.categoric;
          } else {
            disableNumericMethods = false;
            debugPrint('Error: selected is NULL!!!');
          }

          return ChoiceChip(
            label: Text(transform),
            selectedColor: Colors.lightBlue[200],
            backgroundColor:
                disableNumericMethods ? Colors.grey[300] : Colors.lightBlue[50],
            shadowColor: Colors.grey,
            pressElevation: 8.0,
            elevation: 2.0,
            selected: selectedTransform == transform,
            onSelected: disableNumericMethods
                ? null
                : (bool selected) {
                    setState(() {
                      selectedTransform = selected ? transform : '';
                    });
                  },
          );
        }).toList(),
      ),
    );
  }

  // Initialize a TextEditingController for the CONSTANT value.

  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed
    _controller.dispose();
    super.dispose();
  }

  Widget constantEntry() {
    return SizedBox(
      width: 150,
      child: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          labelText: 'Constant',
          border: OutlineInputBorder(),
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
        case 'Zero/Missing':
          rSource(context, ref, 'transform_impute_zero_missing');
        case 'Mean':
          rSource(context, ref, 'transform_impute_mean_numeric');
        case 'Median':
          rSource(context, ref, 'transform_impute_median_numeric');
        case 'Mode':
          rSource(context, ref, 'transform_impute_mode');
        case 'Constant':
          rSource(context, ref, 'transform_impute_constant');
        default:
          showUnderConstruction(context);
      }
      // Notice that rSource is asynchronous so this glimpse is oftwn happening
      // before the above transformation.
      //
      // rSource(context, ref, 'glimpse');
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
            variableChooser(inputs, selected, ref),
            configWidgetSpace,
            transformChooser(),
            configWidgetSpace,
            constantEntry(),
            configWidgetSpace,
          ],
        ),
      ],
    );
  }
}
