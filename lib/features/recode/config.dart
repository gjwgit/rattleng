/// Widget to configure the RECODE feature of the TRANSFORM tab.
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Tuesday 2024-10-15 08:44:14 +1100 Graham Williams>
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
import 'package:rattle/providers/number.dart';
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/providers/selected.dart';
// TODO 20240819 gjw RENAME SELECTED2 TO SECONDARY
import 'package:rattle/providers/selected2.dart';
import 'package:rattle/providers/vars/types.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/utils/get_inputs.dart';
import 'package:rattle/utils/show_under_construction.dart';
import 'package:rattle/utils/variable_chooser.dart';
import 'package:rattle/widgets/activity_button.dart';
import 'package:rattle/widgets/choice_chip_tip.dart';
import 'package:rattle/widgets/number_field.dart';

// TODO 20240819 gjw REQUIRES A COMPREHENSIVE CLEANUP/STRUCTURE

/// A StatefulWidget to pass the ref across to the rSource as well as to monitor
/// the selected variable.

class RecodeConfig extends ConsumerStatefulWidget {
  const RecodeConfig({super.key});

  @override
  ConsumerState<RecodeConfig> createState() => RecodeConfigState();
}

class RecodeConfigState extends ConsumerState<RecodeConfig> {
  bool _isLoading = false;

  // TODO 20240819 gjw EACH WIDGET NEEDS A COMMENT

  // the reason we use this instead of the provider is that the provider will only be updated after build.
  // Before build, selected contains the most recent value.
  String selected = 'NULL';
  String selectedTransform = '';

  List<String> numericMethods = [
    'Quantiles',
    'KMeans',
    'Equal Width',
  ];

  List<String> categoricMethods = [
    'Indicator Variable',
    'Join Categorics',
    // 'As Categoric',
    // 'As Numeric',
  ];

  // BUILD button action.

  void buildAction() {
    // Run the R scripts.

    switch (selectedTransform) {
      case 'Quantiles':
        rSource(context, ref, ['transform_recode_quantile']);
      case 'KMeans':
        rSource(context, ref, ['transform_recode_kmeans']);
      case 'Equal Width':
        rSource(context, ref, ['transform_recode_equal_width']);
      case 'Indicator Variable':
        rSource(context, ref, ['transform_recode_indicator_variable']);
      case 'Join Categorics':
        rSource(context, ref, ['transform_recode_join_categoric']);
      // case 'As Categoric':
      //   rSource(context, ref, ['transform_rescale_log10_numeric']);
      // case 'As Numeric':
      //   rSource(context, ref, ['transform_rescale_rank']);
      default:
        showUnderConstruction(context);
    }
  }

  Widget recodeChooser(inputs, selected2) {
    final TextEditingController valCtrl = TextEditingController();
    valCtrl.text = ref.read(numberProvider.notifier).state.toString();

    bool isNumeric = true;

    // On startup with no dataset (so nothing selected) the default is to enable
    // all the chips.

    if (selected != 'NULL') {
      isNumeric = ref.read(typesProvider)[selected] == Type.numeric;
    }

    // TODO 20240819 gjw WHERE ARE THE TOOLTIPS?

    return Row(
      children: [
        ChoiceChipTip(
          options: numericMethods,
          selectedOption: selectedTransform,
          enabled: isNumeric,
          onSelected: (String? selected) {
            setState(() {
              selectedTransform = selected ?? '';
            });
          },
        ),
        configWidgetGap,
        NumberField(
          label: 'Number',
          controller: valCtrl,
          stateProvider: numberProvider,
          validator: (value) => validateInteger(value, min: 1),
          inputFormatter: FilteringTextInputFormatter.digitsOnly,
          enabled: isNumeric,
        ),
        configWidgetGap,
        ChoiceChipTip(
          enabled: selected == 'NULL' || !isNumeric,
          options: categoricMethods,
          selectedOption: !isNumeric ? selectedTransform : '',
          onSelected: (String? selected) {
            setState(() {
              selectedTransform = selected ?? '';
            });
          },
        ),
        configWidgetGap,
        Expanded(
          child: variableChooser(
            'Secondary',
            inputs,
            selected2,
            ref,
            selected2Provider,
            enabled: true,
            onChanged: (String? value) {
              ref.read(selected2Provider.notifier).state =
                  value ?? 'IMPOSSIBLE';
              // reset after selection
              selectedTransform = ref.read(typesProvider)[value] == Type.numeric
                  ? numericMethods.first
                  : categoricMethods.first;
            },
            tooltip: '''

            Select a secondary variable to assist in the recoding process.
              
            ''',
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // updateVariablesProvider(ref);
    List<String> inputs = getInputsAndIgnoreTransformed(ref);
    selected = ref.watch(selectedProvider);
    if (selected == 'NULL' && inputs.isNotEmpty) {
      setState(() {
        selected = inputs.first;
        // initialise the chip selection
        selectedTransform = ref.read(typesProvider)[selected] == Type.numeric
            ? numericMethods.first
            : categoricMethods.first;
        debugPrint('selected changed to $selected');
      });
    }
    // This is to ensure if we come back later, the selection is not cleared
    if (selected != 'NULL' && selectedTransform == '') {
      selectedTransform = ref.read(typesProvider)[selected] == Type.numeric
          ? numericMethods.first
          : categoricMethods.first;
    }

    String selected2 = ref.watch(selected2Provider);
    if (selected2 == 'NULL' && inputs.isNotEmpty) {
      selected2 = inputs[1];
    }

    return Stack(
      children: [
        Column(
          children: [
            configTopGap,
            Row(
              children: [
                configTopGap,
                ActivityButton(
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });

                    ref.read(selectedProvider.notifier).state = selected;
                    ref.read(selected2Provider.notifier).state = selected2;
                    buildAction();
                    //wait for 5 seconds before switching to the text page.
                    // It takes time for the R script to run.

                    await Future.delayed(const Duration(seconds: 5));

                    setState(() {
                      _isLoading = false;
                    });

                    ref.read(recodePageControllerProvider).animateToPage(
                          1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                  },
                  child: const Text('Recode Variable Values'),
                ),
                configWidgetGap,
                variableChooser(
                  'Variable',
                  inputs,
                  selected,
                  ref,
                  selectedProvider,
                  enabled: true,
                  onChanged: (String? value) {
                    setState(() {
                      ref.read(selectedProvider.notifier).state =
                          value ?? 'IMPOSSIBLE';
                      // Reset the selected transform based on the variable type

                      selectedTransform =
                          ref.read(typesProvider)[value] == Type.numeric
                              ? numericMethods.first
                              : categoricMethods.first;
                    });
                  },
                  tooltip: '''

                  Choose the primary variable to be recoded.
                  
                  ''',
                ),
              ],
            ),
            configTopGap,
            recodeChooser(inputs, selected2),
          ],
        ),
        if (_isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black
                  .withOpacity(0.3), // Optional: adds a translucent overlay
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }
}
