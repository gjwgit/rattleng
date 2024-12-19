/// Widget to configure the RECODE feature of the TRANSFORM tab.
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Sunday 2024-12-15 16:01:45 +1100 Graham Williams>
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

  // The reason we use this instead of the provider is that the provider will only be updated after build.
  // Before build, selected contains the most recent value.

  String selected = 'NULL';
  String selectedTransform = '';
  String selectedAs = '';

  List<String> numericMethods = [
    'Quantiles',
    'KMeans',
    'Equal Width',
  ];

  List<String> asMethods = [
    'As Categoric',
    'As Numeric',
  ];

  Map<String, String> asMethodsTooltips = {
    'As Categoric': '''

      Multiply out the selected numeric variables into a new single variable.

      ''',
    'As Numeric': '''

      Multiply out the selected categoric variables into a new single variable.
    
      ''',
  };

  Map<String, String> numericMethodsTooltips = {
    'Quantiles': '''

      Each bin will have approximately the same number of observations.
      If the Data tab includes a Weight variable, then the observations 
      are weighted when performing the binning.

      ''',
    'KMeans': '''

      A kmeans clustering will be used to bin the variable.
    
      ''',
    'Equal Width': '''

      The min to max range will be split into equal width bins.

      ''',
  };

  List<String> categoricMethods = [
    'Indicator Variable',
    'Join Categorics',
    // 'As Categoric',
    // 'As Numeric',
  ];

  Map<String, String> categoricMethodsTooltips = {
    'Indicator Variable': '''

      Turn a categoric into a collection of numeric (0,1) variables.

      ''',
    'Join Categorics': '''

      Combine multiple categoric variables into just one.
      A join of categoric variables requires two categoric variables.
      Please select two categoric variables, then Execute.
    
      ''',
  };

  // BUILD button action.

  void buildAction() {
    // Run the R scripts.

    switch (selectedTransform) {
      case 'Quantiles':
        rSource(context, ref, ['transform_recode_quantile']);
        break;
      case 'KMeans':
        rSource(context, ref, ['transform_recode_kmeans']);
        break;
      case 'Equal Width':
        rSource(context, ref, ['transform_recode_equal_width']);
        break;
      case 'Indicator Variable':
        rSource(context, ref, ['transform_recode_indicator_variable']);
        break;
      case 'Join Categorics':
        rSource(context, ref, ['transform_recode_join_categoric']);
        break;
      default:
        showUnderConstruction(context);
    }
    switch (selectedAs) {
      case 'As Categoric':
        rSource(context, ref, ['transform_recode_as_categoric']);
        break;
      case 'As Numeric':
        rSource(context, ref, ['transform_recode_as_numeric']);
        break;
    }
  }

  Widget recodeChooser(inputs, selected2) {
    final TextEditingController valCtrl = TextEditingController();
    valCtrl.text = ref.read(numberProvider.notifier).state.toString();

    bool isNumeric = true;

    // On startup with no dataset (so nothing selected), the default is to enable
    // all the chips.

    if (selected != 'NULL') {
      isNumeric = ref.read(typesProvider)[selected] == Type.numeric;
    }

    // TODO 20240819 gjw WHERE ARE THE TOOLTIPS?

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.start, // Align children to the start

        spacing: configWidgetSpace,
        children: [
          configLeftGap,
          ChoiceChipTip(
            options: numericMethods,
            selectedOption: selectedTransform,
            enabled:
                isNumeric, // Dynamic enabling based on the selected variable type
            tooltips: numericMethodsTooltips,
            onSelected: (String? selected) {
              setState(() {
                selectedTransform = selected ?? '';
              });
            },
          ),
          NumberField(
            label: 'Number',
            controller: valCtrl,
            stateProvider: numberProvider,
            validator: (value) => validateInteger(value, min: 1),
            inputFormatter: FilteringTextInputFormatter.digitsOnly,
            enabled: isNumeric,
            tooltip: '''
                
            Set the number of bins to construct.
      
            ''',
          ),
          ChoiceChipTip(
            options: asMethods,
            selectedOption: selectedAs,
            // enabled: isNumeric,
            tooltips: asMethodsTooltips,
            onSelected: (String? selected) {
              setState(() {
                selectedAs = selected ?? '';
              });
            },
          ),
          ChoiceChipTip(
            enabled: selected == 'NULL' || !isNumeric,
            options: categoricMethods,
            selectedOption: !isNumeric ? selectedTransform : '',
            tooltips: categoricMethodsTooltips,
            onSelected: (String? selected) {
              setState(() {
                selectedTransform = selected ?? '';

                // If "Join Categorics" is selected, filter inputs to only categoric types
                if (selectedTransform == 'Join Categorics') {
                  inputs = inputs
                      .where((input) =>
                          ref.read(typesProvider)[input] == Type.categoric)
                      .toList();

                  // Update selected and selected2 to ensure they are valid
                  selected = inputs.isNotEmpty ? inputs.first : 'NULL';
                  selected2 = inputs.length > 1 ? inputs[1] : 'NULL';

                  ref.read(selectedProvider.notifier).state = selected!;
                  ref.read(selected2Provider.notifier).state = selected2;
                }
              });
            },
          ),
        ],
      ),
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

        // Initialize the chip selection.

        selectedTransform = ref.read(typesProvider)[selected] == Type.numeric
            ? numericMethods.first
            : categoricMethods.first;
        debugPrint('selected changed to $selected');
      });
    }

    // This is to ensure if we come back later, the selection is not cleared.

    if (selected != 'NULL' && selectedTransform == '') {
      selectedTransform = ref.read(typesProvider)[selected] == Type.numeric
          ? numericMethods.first
          : categoricMethods.first;
    }

    String selected2 = ref.watch(selected2Provider);
    if (selected2 == 'NULL' && inputs.isNotEmpty) {
      selected2 = inputs[1];
    }

    bool isNumeric = true;

    // On startup with no dataset (so nothing selected), the default is to enable
    // all the chips.

    if (selected != 'NULL') {
      isNumeric = ref.read(typesProvider)[selected] == Type.numeric;
    }
    return Stack(
      children: [
        Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align content to the start
          mainAxisAlignment:
              MainAxisAlignment.start, // Optional: Align vertically
          spacing: configRowSpace,
          children: [
            configTopGap,
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start, // Align to start

                spacing: configWidgetSpace,
                children: [
                  configTopGap,
                  ActivityButton(
                    onPressed: () async {
                      setState(() {
                        _isLoading = selectedTransform == 'Quantiles';
                      });

                      ref.read(selectedProvider.notifier).state = selected;
                      ref.read(selected2Provider.notifier).state = selected2;
                      buildAction();

                      if (selectedTransform == 'Quantiles') {
                        await Future.delayed(const Duration(seconds: 5));
                      }

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
                  variableChooser(
                    'Variable',
                    selectedTransform == 'Join Categorics'
                        ? inputs
                            .where((input) =>
                                ref.read(typesProvider)[input] ==
                                Type.categoric)
                            .toList()
                        : inputs,
                    selected,
                    ref,
                    selectedProvider,
                    enabled: true,
                    onChanged: (String? value) {
                      setState(() {
                        ref.read(selectedProvider.notifier).state =
                            value ?? 'IMPOSSIBLE';

                        // Update isNumeric dynamically based on the selected variable type
                        isNumeric =
                            ref.read(typesProvider)[value] == Type.numeric;
                      });
                    },
                    tooltip: '''
    Choose the primary variable to be recoded.
  ''',
                  ),
                  variableChooser(
                    'Secondary',
                    selectedTransform == 'Join Categorics'
                        ? inputs
                            .where((input) =>
                                ref.read(typesProvider)[input] ==
                                Type.categoric)
                            .toList()
                        : inputs,
                    selected2,
                    ref,
                    selected2Provider,
                    enabled: true,
                    onChanged: (String? value) {
                      ref.read(selected2Provider.notifier).state =
                          value ?? 'IMPOSSIBLE';
                    },
                    tooltip: '''
    Select a secondary variable to assist in the recoding process.
  ''',
                  ),
                ],
              ),
            ),
            recodeChooser(inputs, selected2),
          ],
        ),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
