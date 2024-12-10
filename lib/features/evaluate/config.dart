/// Widget to configure the EVALUATE tab.
///
/// Copyright (C) 2024, Togaware Pty Ltd.
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
      provider: rpartTreeEvaluateProvider,
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
      label: 'Neural Net',
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
    return Column(
      children: [
        configBotGap,
        Row(
          children: [
            configLeftGap,
            ActivityButton(
              pageControllerProvider: evaluatePageControllerProvider,
              onPressed: () async {
                bool rpartExecuted = ref.watch(rpartTreeEvaluateProvider);
                bool ctreeExecuted = ref.watch(cTreeEvaluateProvider);

                String mbe = 'model_build_evaluate';
                String er = 'evaluate_rpart';
                String ec = 'evaluate_ctree';

                await rSource(
                  context,
                  ref,
                  [mbe],
                );

                if (rpartExecuted) {
                  await rSource(
                    context,
                    ref,
                    [er],
                  );
                }

                if (ctreeExecuted) {
                  await rSource(
                    context,
                    ref,
                    [ec],
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
            configLeftGap,
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
                  configWidgetGap,
                ],
              );
            }).toList(),
          ],
        ),
        configRowGap,
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
