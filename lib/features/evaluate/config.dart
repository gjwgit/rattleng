/// Widget to configure the FOREST tab: button.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Monday 2024-10-07 06:47:54 +1100 Graham Williams>
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
import 'package:rattle/providers/forest.dart';
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/providers/tree_algorithm.dart';

import 'package:rattle/r/source.dart';
import 'package:rattle/utils/get_target.dart';
import 'package:rattle/widgets/activity_button.dart';
import 'package:rattle/widgets/choice_chip_tip.dart';
import 'package:rattle/widgets/labelled_checkbox.dart';
import 'package:rattle/widgets/number_field.dart';
import 'package:rattle/widgets/vector_number_field.dart';

/// Descriptive tooltips for different algorithm types,
/// explaining the splitting method and potential biases.

Map forestTooltips = {
  AlgorithmType.conditional: '''

      Build multiple decision trees using random samples of 
      data and features, then aggregate their predictions.

      ''',
  AlgorithmType.traditional: '''
      
      Adjust for covariate distributions during tree construction 
      to provide unbiased variable importance measures.
      
      ''',
};

/// The FOREST tab config currently consists of just a BUILD button.
///
/// This is a StatefulWidget to pass the ref across to the rSouorce.

class ForestConfig extends ConsumerStatefulWidget {
  const ForestConfig({super.key});

  @override
  ConsumerState<ForestConfig> createState() => ForestConfigState();
}

class ForestConfigState extends ConsumerState<ForestConfig> {
  final TextEditingController _treesController = TextEditingController();
  final TextEditingController _variablesController = TextEditingController();
  final TextEditingController _treeNoController = TextEditingController();

  @override
  void dispose() {
    // Dispose the controllers to free up resources.

    _treesController.dispose();
    _variablesController.dispose();
    _treeNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int treeNum = ref.watch(treeNumForestProvider);

    AlgorithmType selectedAlgorithm =
        ref.read(algorithmForestProvider.notifier).state;

    return Column(
      children: [
        // Space above the beginning of the configs.

        configBotGap,

        Row(
          children: [
            // Space to the left of the configs.

            configLeftGap,

            // The BUILD button.

            ActivityButton(
              pageControllerProvider:
                  forestPageControllerProvider, // Optional navigation

              onPressed: () async {
                selectedAlgorithm == AlgorithmType.traditional
                    ? await rSource(
                        context,
                        ref,
                        ['model_template', 'model_build_random_forest'],
                      )
                    : await rSource(
                        context,
                        ref,
                        ['model_template', 'model_build_conditional_forest'],
                      );

                await ref.read(forestPageControllerProvider).animateToPage(
                      // Index of the second page.
                      1,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
              },
              child: const Text('Build Random Forest'),
            ),

            configWidgetGap,

            Text('Target: ${getTarget(ref)}'),

            configWidgetGap,

            ChoiceChipTip<AlgorithmType>(
              options: AlgorithmType.values,
              getLabel: (AlgorithmType type) => type.displayName,
              selectedOption: selectedAlgorithm,
              tooltips: forestTooltips,
              onSelected: (AlgorithmType? selected) {
                setState(() {
                  if (selected != null) {
                    selectedAlgorithm = selected;
                    ref.read(algorithmForestProvider.notifier).state = selected;
                  }
                });
              },
            ),
          ],
        ),

        configRowGap,

        Row(
          children: [
            // Space to the left of the configs.

            configLeftGap,

            NumberField(
              label: 'Trees:',
              key: const Key('treeForest'),
              controller: _treesController,
              tooltip: '''

                The ntree parameter specifies the number of trees to grow in the forest.

                ''',
              inputFormatter: FilteringTextInputFormatter.allow(
                RegExp(r'^[0-9]*\.?[0-9]{0,4}$'),
              ),
              validator: (value) => validateInteger(value, min: 10),
              stateProvider: treeNumForestProvider,
              interval: 10,
            ),

            configWidgetGap,

            NumberField(
              label: 'Variables:',
              key: const Key('variablesForest'),
              controller: _variablesController,
              tooltip: '''

                The mtry parameter defines the number of variables 
                randomly selected as candidates at each split in the trees.

                ''',
              validator: validateVector,
              inputFormatter:
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9,\s]')),
              stateProvider: predictorNumForestProvider,
            ),

            configWidgetGap,

            NumberField(
              label: 'NO. Tree:',
              key: const Key('treeNoForest'),
              controller: _treeNoController,
              tooltip: '''

                Which tree to display.

                ''',
              max: treeNum,
              validator: validateVector,
              inputFormatter:
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9,\s]')),
              stateProvider: treeNoForestProvider,
            ),

            configWidgetGap,

            LabelledCheckbox(
              key: const Key('imputeForest'),
              tooltip: '''

              Impute the median (numerical) or most frequent (categoric) value 
              for missing data using na.roughfix() from randomForest.

              ''',
              label: 'Impute',
              provider: imputeForestProvider,
            ),
          ],
        ),
      ],
    );
  }
}
