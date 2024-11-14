/// Widget to configure the EVALUATE tab: button.
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

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rattle/constants/spacing.dart';
import 'package:rattle/providers/evaluate.dart';
import 'package:rattle/utils/check_function_executed.dart';
import 'package:rattle/widgets/labelled_checkbox.dart';

/// The EVALUATE tab config currently consists of just a BUILD button.
///
/// This is a StatefulWidget to pass the ref across to the rSource.

class EvaluateConfig extends ConsumerStatefulWidget {
  const EvaluateConfig({super.key});

  @override
  ConsumerState<EvaluateConfig> createState() => EvaluateConfigState();
}

class EvaluateConfigState extends ConsumerState<EvaluateConfig> {
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
    bool treeEvaluateEnabled = checkFunctionExecuted(
          ref,
          [
            'print(model_rpart)',
            'printcp(model_rpart)',
          ],
          [
            'model_tree_rpart.svg',
          ],
        ) ||
        checkFunctionExecuted(
          ref,
          [
            'print(model_ctree)',
            'summary(model_ctree)',
          ],
          [
            'model_tree_ctree.svg',
          ],
        );
    return Column(
      children: [
        // Space above the beginning of the configs.

        configBotGap,

        Row(
          children: [
            // Space to the left of the configs.

            configLeftGap,

            LabelledCheckbox(
              key: const Key('treeEvaluate'),
              tooltip: '''

              

              ''',
              label: 'Tree',
              provider: treeEvaluateProvider,
              enabled: treeEvaluateEnabled,
              onSelected: (ticked) {
                setState(() {
                  if (ticked != null) {
                    ref.read(treeEvaluateProvider.notifier).state = ticked;
                  }
                });
              },
            ),

            configWidgetGap,

            LabelledCheckbox(
              key: const Key('boostEvaluate'),
              tooltip: '''

              

              ''',
              label: 'Boost',
              provider: boostEvaluateProvider,
              enabled: false,
              onSelected: (ticked) {
                setState(() {
                  if (ticked != null) {
                    ref.read(boostEvaluateProvider.notifier).state = ticked;
                  }
                });
              },
            ),

            configWidgetGap,

            LabelledCheckbox(
              key: const Key('forestEvaluate'),
              tooltip: '''

              

              ''',
              label: 'Forest',
              provider: forestEvaluateProvider,
              enabled: false,
              onSelected: (ticked) {
                setState(() {
                  if (ticked != null) {
                    ref.read(forestEvaluateProvider.notifier).state = ticked;
                  }
                });
              },
            ),

            configWidgetGap,

            LabelledCheckbox(
              key: const Key('svmEvaluate'),
              tooltip: '''

              

              ''',
              label: 'SVM',
              provider: svmEvaluateProvider,
              enabled: false,
              onSelected: (ticked) {
                setState(() {
                  if (ticked != null) {
                    ref.read(svmEvaluateProvider.notifier).state = ticked;
                  }
                });
              },
            ),

            configWidgetGap,

            LabelledCheckbox(
              key: const Key('linearEvaluate'),
              tooltip: '''

              

              ''',
              label: 'Linear',
              provider: linearEvaluateProvider,
              enabled: false,
              onSelected: (ticked) {
                setState(() {
                  if (ticked != null) {
                    ref.read(linearEvaluateProvider.notifier).state = ticked;
                  }
                });
              },
            ),

            configWidgetGap,

            LabelledCheckbox(
              key: const Key('neuralNetEvaluate'),
              tooltip: '''

              

              ''',
              label: 'Neural Net',
              provider: neuralNetEvaluateProvider,
              enabled: false,
              onSelected: (ticked) {
                setState(() {
                  if (ticked != null) {
                    ref.read(neuralNetEvaluateProvider.notifier).state = ticked;
                  }
                });
              },
            ),

            configWidgetGap,

            LabelledCheckbox(
              key: const Key('KMeansEvaluate'),
              tooltip: '''

              

              ''',
              label: 'KMeans',
              provider: kMeansEvaluateProvider,
              enabled: false,
              onSelected: (ticked) {
                setState(() {
                  if (ticked != null) {
                    ref.read(kMeansEvaluateProvider.notifier).state = ticked;
                  }
                });
              },
            ),

            configWidgetGap,

            LabelledCheckbox(
              key: const Key('HClustEvaluate'),
              tooltip: '''

              

              ''',
              label: 'HClust',
              provider: hClusterEvaluateProvider,
              enabled: false,
              onSelected: (ticked) {
                setState(() {
                  if (ticked != null) {
                    ref.read(hClusterEvaluateProvider.notifier).state = ticked;
                  }
                });
              },
            ),
          ],
        ),

        configRowGap,
      ],
    );
  }
}
