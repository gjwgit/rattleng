/// Widget to configure the EVALUATE tab.
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Friday 2024-12-20 20:50:36 +1100 Graham Williams>
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
/// Authors: Zheyuan Xu

library;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/spacing.dart';
import 'package:rattle/constants/style.dart';
import 'package:rattle/providers/evaluate.dart';
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/utils/check_function_executed.dart';
import 'package:rattle/widgets/activity_button.dart';
import 'package:rattle/widgets/choice_chip_tip.dart';
import 'package:rattle/widgets/labelled_checkbox.dart';

class EvaluateConfig extends ConsumerStatefulWidget {
  const EvaluateConfig({super.key});

  @override
  ConsumerState<EvaluateConfig> createState() => EvaluateConfigState();
}

class EvaluateConfigState extends ConsumerState<EvaluateConfig> {
  final List<_ModelConfig> modelConfigs = [
    _ModelConfig(
      key: 'treeEvaluate',
      label: 'Tree',
      checkCommands: [
        ['print(model_rpart)', 'printcp(model_rpart)'],
        ['print(model_ctree)', 'summary(model_ctree)'],
      ],
      checkFiles: [
        ['model_tree_rpart.svg'],
        ['model_tree_ctree.svg'],
      ],
      provider: treeEvaluateProvider,
    ),
    _ModelConfig(
      key: 'forestEvaluate',
      label: 'Forest',
      checkCommands: [
        ['print(model_conditionalForest)', 'print(importance_df)'],
        ['print(model_randomForest)', 'printRandomForests'],
      ],
      checkFiles: [
        ['model_conditional_forest.svg'],
        [
          'model_random_forest_varimp.svg',
          'model_random_forest_error_rate.svg',
          'model_random_forest_oob_roc_curve.svg',
        ],
      ],
      provider: forestEvaluateProvider,
    ),
    _ModelConfig(
      key: 'boostEvaluate',
      label: 'Boost',
      checkCommands: [
        ['print(model_ada)', 'summary(model_ada)'],
        ['print(model_xgb)', 'summary(model_xgb)'],
      ],
      checkFiles: [
        ['model_ada_boost.svg'],
        ['model_xgb_importance.svg'],
      ],
      provider: boostEvaluateProvider,
    ),
    _ModelConfig(
      key: 'svmEvaluate',
      label: 'SVM',
      checkCommands: [
        ['print(svm_model)'],
      ],
      checkFiles: [[]],
      provider: svmEvaluateProvider,
    ),
    _ModelConfig(
      key: 'linearEvaluate',
      label: 'Linear',
      checkCommands: [
        [
          'print(summary(model_glm))',
          'print(anova(model_glm, test = "Chisq"))',
        ],
      ],
      checkFiles: [
        ['model_glm_diagnostic_plots.svg'],
      ],
      provider: linearEvaluateProvider,
    ),
    _ModelConfig(
      key: 'neuralNetEvaluate',
      label: 'Neural',
      checkCommands: [
        ['print(model_neuralnet)', 'summary(model_neuralnet)'],
        ['print(model_nn)', 'summary(model_nn)'],
      ],
      checkFiles: [
        ['model_neuralnet.svg'],
        ['model_nn_nnet.svg'],
      ],
      provider: neuralNetEvaluateProvider,
    ),
    _ModelConfig(
      key: 'KMeansEvaluate',
      label: 'KMeans',
      checkCommands: [
        ['print(colMeans(tds))'],
      ],
      checkFiles: [
        ['model_cluster_discriminant.svg'],
      ],
      provider: kMeansEvaluateProvider,
    ),
    _ModelConfig(
      key: 'HClustEvaluate',
      label: 'HClust',
      checkCommands: [
        ['print("Within-Cluster Sum of Squares:")'],
      ],
      checkFiles: [
        ['model_cluster_hierarchical.svg'],
      ],
      provider: hClusterEvaluateProvider,
    ),
  ];

  Map<String, String> datasetTypes = {
    'Training': '''

    Evaluate the model using the training dataset.
    This will give an optimistic estimate of the 
    performance of the model.

    ''',
    'Validation': '''

    Evaluate the model using the validation dataset.
    This is used whilst the model parameters are 
    still being tuned but not for the final unbiased
    estimate of error. This option is only available
    if partitioning is enabled in the Data tab and a
    validation dataset is specified.

    ''',
    'Testing': '''

    Evaluate the performance of the model over the
    testing dataset, which is the remainder of the
    dataset not used for building, and so will provide
    an unbiased estimate. This option is only available
    if partitioning is enabled in the Data tab and a
    testing dataset is specified.

    ''',
    'Full': '''

    Score the whole dataset.

    ''',
  };

  bool _isEvaluationEnabled(_ModelConfig config) {
    for (var i = 0; i < config.checkCommands.length; i++) {
      if (checkFunctionExecuted(
        ref,
        config.checkCommands[i],
        config.checkFiles[i],
      )) {
        return true;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    String datasetType = ref.watch(datasetTypeProvider.notifier).state;

    return Column(
      spacing: configRowSpace,
      children: [
        // 20241215 gjw Add comment to allow empty lines between widgets.

        configTopGap,

        Row(
          spacing: configWidgetSpace,
          children: [
            // 20241215 gjw Add comment to allow empty lines between widgets.

            configLeftGap,

            ActivityButton(
              pageControllerProvider: evaluatePageControllerProvider,
              onPressed: () async {
                // Retrieve the boolean state indicating if the evaluation was executed.

                bool adaBoostExecuted = ref.watch(adaBoostEvaluateProvider);
                bool boostTicked = ref.watch(boostEvaluateProvider);
                bool conditionalForestExecuted =
                    ref.watch(conditionalForestEvaluateProvider);
                bool ctreeExecuted = ref.watch(cTreeEvaluateProvider);
                bool forestTicked = ref.watch(forestEvaluateProvider);
                bool nnetExecuted = ref.watch(nnetEvaluateProvider);
                bool neuralTicked = ref.watch(neuralNetEvaluateProvider);
                bool randomForestExecuted =
                    ref.watch(randomForestEvaluateProvider);
                bool rpartExecuted = ref.watch(rpartTreeEvaluateProvider);
                bool svmExecuted = ref.watch(svmEvaluateProvider);
                bool treeExecuted = ref.watch(treeEvaluateProvider);
                bool xgBoostExecuted = ref.watch(xgBoostEvaluateProvider);

                // 20241220 gjw Identify constants corresponding to the various
                // evaluation commands for each model to generate the required
                // TEMPLATE variables.

                String ea = 'evaluate_adaboost';
                String ec = 'evaluate_ctree';
                String en = 'evaluate_nnet';
                String er = 'evaluate_model_rpart';
                String es = 'evaluate_svm';
                String ex = 'evaluate_xgboost';

                String ecf = 'evaluate_conditional_forest';
                String erf = 'evaluate_random_forest';

                // 20241220 gjw One of the following templates then needs to be
                // run to convert the appropriate predictions and probabilities
                // to the variables that are non-specific to a dataset
                // partition.

                String ttr = 'evaluate_template_tr';
                String ttu = 'evaluate_template_tu';
                String tte = 'evaluate_template_te';

                // 20241220 gjw Finally we will run the generic templates for
                // the various performance measures.

                String em = 'evaluate_measure_error_matrix';
                String ro = 'evaluate_measure_roc';

                // Check if rpart model evaluation was executed.

                if (rpartExecuted && treeExecuted) {
                  await rSource(
                    context,
                    ref,
                    // 20241220 gjw Let's try out ttu instead of ttr. This will
                    // then be chosen via the GUI.
                    [er, ttu, em, ro],
                  );
                }

                // Check if ctree model evaluation was executed.

                if (ctreeExecuted) {
                  await rSource(
                    context,
                    ref,
                    [ec, ttr, em, ro],
                  );
                }

                // Check if Random Forest evaluation was executed
                // and forest box was ticked.

                if (randomForestExecuted && forestTicked) {
                  await rSource(
                    context,
                    ref,
                    [erf, tte, em, ro],
                  );
                }

                // Check if Conditional Forest evaluation was executed
                // and forest box was ticked.

                if (conditionalForestExecuted && forestTicked) {
                  await rSource(
                    context,
                    ref,
                    [ecf, em, ro],
                  );
                }

                // Check if AdaBoost evaluation was executed and boost box is enabled.

                if (adaBoostExecuted && boostTicked) {
                  await rSource(
                    context,
                    ref,
                    [ea, em, ro],
                  );
                }

                // Check if XGBoost evaluation was executed and boost box is enabled.

                if (xgBoostExecuted && boostTicked) {
                  await rSource(
                    context,
                    ref,
                    [ex, em, ro],
                  );
                }

                // Check if SVM evaluation was executed.

                if (svmExecuted) {
                  await rSource(
                    context,
                    ref,
                    [es, em, ro],
                  );
                }

                // Check if Neural Network box was ticked and neural network methods are enabled.

                if (neuralTicked && nnetExecuted) {
                  await rSource(
                    context,
                    ref,
                    [en, em, ro],
                  );
                }

                await ref.read(evaluatePageControllerProvider).animateToPage(
                      // Index of the second page.
                      1,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
              },
              child: const Text('Execute'),
            ),

            const Text('Model:', style: normalTextStyle),
            ...modelConfigs.map((config) {
              bool enabled = _isEvaluationEnabled(config);

              return Row(
                children: [
                  LabelledCheckbox(
                    key: Key(config.key),
                    tooltip: '',
                    label: config.label,
                    provider: config.provider,
                    enabled: enabled,
                    onSelected: (ticked) {
                      setState(() {
                        if (ticked != null) {
                          ref.read(config.provider.notifier).state = ticked;
                        }
                      });
                    },
                  ),
                ],
              );
            }).toList(),
          ],
        ),
        Row(
          spacing: configWidgetSpace,
          children: [
            configLeftGap,
            Text('Data: '),
            ChoiceChipTip<String>(
              options: datasetTypes.keys.toList(),
              selectedOption: datasetType,
              tooltips: datasetTypes,
              onSelected: (chosen) {
                setState(() {
                  if (chosen != null) {
                    datasetType = chosen;
                    ref.read(datasetTypeProvider.notifier).state = chosen;
                  }
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _ModelConfig {
  final String key;
  final String label;
  final List<List<String>> checkCommands;
  final List<List<String>> checkFiles;
  final StateProvider<bool> provider;

  const _ModelConfig({
    required this.key,
    required this.label,
    required this.checkCommands,
    required this.checkFiles,
    required this.provider,
  });
}
