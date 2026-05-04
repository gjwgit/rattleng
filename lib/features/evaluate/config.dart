/// A widget to configure the EVALUATE tab.
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://opensource.org/license/gpl-3-0
//
// Time-stamp: "Wednesday 2025-09-17 09:04:51 +1000 Graham Williams"
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
// this program.  If not, see <https://opensource.org/license/gpl-3-0>.
///
/// Authors: Zheyuan Xu

library;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rattle/constants/spacing.dart';
import 'package:rattle/constants/style.dart';
import 'package:rattle/features/evaluate/activity_button.dart';
import 'package:rattle/providers/evaluate.dart';
import 'package:rattle/providers/partition.dart';
import 'package:rattle/providers/settings.dart';
import 'package:rattle/providers/tree.dart';
import 'package:rattle/utils/check_function_executed.dart';
import 'package:rattle/utils/is_numeric_target.dart';
import 'package:rattle/widgets/choice_chip_tip.dart';
import 'package:rattle/widgets/labelled_checkbox.dart';

class EvaluateConfig extends ConsumerStatefulWidget {
  const EvaluateConfig({super.key});

  @override
  ConsumerState<EvaluateConfig> createState() => EvaluateConfigState();
}

class EvaluateConfigState extends ConsumerState<EvaluateConfig> {
  final List<ModelConfig> modelConfigs = [
    ModelConfig(
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
    ModelConfig(
      key: 'forestEvaluate',
      label: 'Forest',
      checkCommands: [
        ['print(model_conditionalForest)', 'print(importance_df)'],
        ['print(model_randomForest)', 'printRandomForest'],
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
    ModelConfig(
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
    ModelConfig(
      key: 'svmEvaluate',
      label: 'SVM',
      checkCommands: [
        ['print(model_svm)'],
      ],
      checkFiles: [[]],
      provider: svmEvaluateProvider,
    ),
    ModelConfig(
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
    ModelConfig(
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
      provider: neuralEvaluateProvider,
    ),
    ModelConfig(
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
    ModelConfig(
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

    Evaluate the model using the **training** dataset.  This will give an
    optimistic estimate of the performance of the model since it is using the
    same data that trained the model to then test the model. It should do well.

    ''',
    'Tuning': '''

    Evaluate the model using the **tuning/validation** dataset.  This is used
    whilst the model parameters are still being tuned but not for the final
    unbiased estimate of error. This option is only available if partitioning is
    enabled in the Data tab and a tuning/validation dataset is specified.

    ''',
    'Testing': '''

    Evaluate the performance of the model over the **testing** dataset, which is
    the remainder of the dataset not used for training (and tuning), and so will
    provide an unbiased estimate. This option is only available if partitioning
    is enabled in the Data tab and a testing dataset is specified.

    ''',
    'Complete': '''

    Evaluate the performance on the **complete** dataset.

    ''',
  };

  bool _isEvaluationEnabled(ModelConfig config) {
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

  // Load settings from shared preferences and update providers.

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    // Load useValidation setting from shared preferences.

    ref.read(useValidationSettingProvider.notifier).state =
        prefs.getBool('useValidation') ?? false;
  }

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    String datasetType = ref.watch(datasetTypeProvider.notifier).state;

    // For regression (numeric target) adaboost is classification-only so
    // keep it disabled; all other models support regression and should remain
    // enabled when a model has been built.

    bool numericTarget = isNumericTarget(ref);

    return Column(
      spacing: configRowSpace,
      children: [
        // 20241215 gjw Add comment into this file here to force the automatic
        // code formatter to allow empty lines between widgets.
        configTopGap,

        Row(
          spacing: configWidgetSpace,
          children: [
            // 20241215 gjw Add comment to allow empty lines between widgets.
            configLeftGap,

            evaluateActivityButton(context, ref),

            const Text('Model:', style: normalTextStyle),
            ...modelConfigs.map((config) {
              // AdaBoost is a classification-only algorithm; disable it when
              // the target is numeric.  All other models support regression.

              bool adaboostOnly =
                  numericTarget && config.key == 'boostEvaluate';
              bool enabled = _isEvaluationEnabled(config) && !adaboostOnly;

              String buildMsg = enabled
                  ? ''
                  : adaboostOnly
                      ? ' AdaBoost is a classification-only algorithm and '
                          'cannot be used when the target variable is numeric.'
                      : ' You will need to build a ${config.label} model '
                          'before you can evaluate it. '
                          'Visit the **Model** tab to do so.';

              return Row(
                children: [
                  LabelledCheckbox(
                    key: Key(config.key),
                    tooltip: 'Evaluate the performace of any '
                        '**${config.label}** model(s).$buildMsg',
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
            }),
          ],
        ),

        Row(
          spacing: configWidgetSpace,
          children: [
            configLeftGap,
            const Text('Evaluation Dataset: '),

            // Widget to display dataset type selection as choice chips with tooltips.
            ChoiceChipTip<String>(
              // Generate list of dataset type options, filtering based on partition toggles.
              options: datasetTypes.keys
                  .where(
                    (key) => ref.read(partitionProvider) || key == 'Complete',
                  )
                  .map(
                    (key) => key == 'Tuning' &&
                            ref.watch(useValidationSettingProvider)
                        ? 'Validation'
                        : key,
                  )
                  .toList(),

              // Set selected option, handling Tuning/Validation text swap and
              // defaulting to Complete when partitions disabled.

              selectedOption: !ref.read(partitionProvider)
                  ? 'Complete'
                  : (datasetType == 'Tuning' &&
                          ref.watch(useValidationSettingProvider)
                      ? 'Validation'
                      : datasetType),

              // Create tooltips map, replacing 'Tuning' key with 'Validation'
              // when validation is enabled and filtering based on partition setting.
              tooltips: Map.fromEntries(
                datasetTypes.entries
                    .where(
                      (entry) =>
                          ref.read(partitionProvider) ||
                          entry.key == 'Complete',
                    )
                    .map(
                      (entry) => MapEntry(
                        entry.key == 'Tuning' &&
                                ref.watch(useValidationSettingProvider)
                            ? 'Validation'
                            : entry.key,
                        entry.value,
                      ),
                    ),
              ),

              // Handle selection changes by updating state and provider.

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

class ModelConfig {
  final String key;
  final String label;
  final List<List<String>> checkCommands;
  final List<List<String>> checkFiles;
  final StateProvider<bool> provider;

  const ModelConfig({
    required this.key,
    required this.label,
    required this.checkCommands,
    required this.checkFiles,
    required this.provider,
  });
}
