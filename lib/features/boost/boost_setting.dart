/// Boost setting for different boost algorithms.
///
/// Time-stamp: <Friday 2024-09-27 10:28:59 +1000 Graham Williams>
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
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
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/spacing.dart';
import 'package:rattle/providers/boost_config.dart';
import 'package:rattle/utils/variable_chooser.dart';
import 'package:rattle/widgets/number_field.dart';

/// Objectives setting of XGBoost.

List<String> modelObjective = [
  'binary:logistic',
  'binary:logitraw',
  'reg:linear',
  'reg:logistic',
];

class BoostSetting extends ConsumerStatefulWidget {
  const BoostSetting({super.key});

  @override
  ConsumerState<BoostSetting> createState() => _BoostSettingState();
}

class _BoostSettingState extends ConsumerState<BoostSetting> {
  // Controllers for the input fields.

  final TextEditingController _boostTreesController = TextEditingController();
  final TextEditingController _boostMaxDepthController =
      TextEditingController();
  final TextEditingController _boostMinSplitController =
      TextEditingController();
  final TextEditingController _boostComplexityController =
      TextEditingController();
  final TextEditingController _boostXValueController = TextEditingController();
  final TextEditingController _boostLearningRateController =
      TextEditingController();
  final TextEditingController _boostThreadsController = TextEditingController();
  final TextEditingController _boostIterationsController =
      TextEditingController();
  final TextEditingController _boostObjectiveController =
      TextEditingController();

  @override
  void dispose() {
    // Dispose the controllers to free up resources.

    _boostTreesController.dispose();
    _boostMaxDepthController.dispose();
    _boostMinSplitController.dispose();
    _boostComplexityController.dispose();
    _boostXValueController.dispose();
    _boostLearningRateController.dispose();
    _boostThreadsController.dispose();
    _boostIterationsController.dispose();
    _boostObjectiveController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _boostTreesController.text =
        ref.read(treesBoostProvider.notifier).state.toString();
    _boostMaxDepthController.text =
        ref.read(maxDepthBoostProvider.notifier).state.toString();
    _boostMinSplitController.text =
        ref.read(minSplitBoostProvider.notifier).state.toString();
    _boostComplexityController.text =
        ref.read(complexityBoostProvider.notifier).state.toString();
    _boostXValueController.text =
        ref.read(xValueBoostProvider.notifier).state.toString();
    _boostLearningRateController.text =
        ref.read(learningRateBoostProvider.notifier).state.toString();
    _boostThreadsController.text =
        ref.read(threadsBoostProvider.notifier).state.toString();
    _boostIterationsController.text =
        ref.read(iterationsBoostProvider.notifier).state.toString();
    _boostObjectiveController.text =
        ref.read(objectiveBoostProvider.notifier).state.toString();

    String algorithm = ref.read(boostAlgorithmProvider.notifier).state;
    String objective = ref.read(objectiveBoostProvider.notifier).state;

    return Column(
      children: [
        configTopSpace,
        Row(
          children: [
            NumberField(
              label: 'Trees:',
              key: const Key('boost_trees'),
              tooltip: '''

              Number of trees in the model; more trees increase accuracy but also complexity.

              ''',
              enabled: algorithm == 'Adaptive',
              controller: _boostTreesController,
              inputFormatter: FilteringTextInputFormatter.digitsOnly,
              validator: (value) => validateInteger(value, min: 1),
              stateProvider: treesBoostProvider,
            ),
            configWidgetSpace,
            NumberField(
              label: 'Max Depth:',
              key: const Key('boost_max_depth'),
              tooltip: '''
        
              Maximum depth of each tree; controls model complexity and risk of overfitting.    

              ''',
              controller: _boostMaxDepthController,
              inputFormatter: FilteringTextInputFormatter.digitsOnly,
              validator: (value) => validateInteger(value, min: 1),
              stateProvider: maxDepthBoostProvider,
            ),
            configWidgetSpace,
            NumberField(
              label: 'Min Split:',
              key: const Key('boost_min_split'),
              tooltip: '''

              Minimum number of samples required to split an internal node.

              ''',
              enabled: algorithm == 'Adaptive',
              controller: _boostMinSplitController,
              inputFormatter: FilteringTextInputFormatter.digitsOnly,
              validator: (value) => validateInteger(value, min: 1),
              stateProvider: minSplitBoostProvider,
            ),
            configWidgetSpace,
            NumberField(
              label: 'Complexity:',
              key: const Key('boost_complexity'),
              tooltip: '''

              Regularization parameter that penalizes complex trees to prevent overfitting.

              ''',
              enabled: algorithm == 'Adaptive',
              controller: _boostComplexityController,
              inputFormatter: FilteringTextInputFormatter.allow(
                RegExp(r'^[0-9]*\.?[0-9]{0,4}$'),
              ),
              interval: 0.0005,
              decimalPlaces: 4,
              validator: (value) => validateDecimal(value),
              stateProvider: complexityBoostProvider,
            ),
            configWidgetSpace,
            NumberField(
              label: 'X Val:',
              key: const Key('boost_x_value'),
              tooltip: '''

              Number of folds in cross-validation; helps estimate model performance.

              ''',
              enabled: algorithm == 'Adaptive',
              controller: _boostXValueController,
              inputFormatter: FilteringTextInputFormatter.digitsOnly,
              validator: (value) => validateInteger(value, min: 1),
              stateProvider: xValueBoostProvider,
            ),
            configWidgetSpace,
          ],
        ),
        configTopSpace,
        Row(
          children: [
            NumberField(
              label: 'Learning Rate:',
              key: const Key('boost_learning_rate'),
              tooltip: '''

              Step size at each iteration; smaller values lead to more robust learning.

              ''',
              enabled: algorithm == 'Extreme',
              controller: _boostLearningRateController,
              inputFormatter: FilteringTextInputFormatter.allow(
                RegExp(r'^[0-9]*\.?[0-9]{0,4}$'),
              ),
              interval: 0.05,
              decimalPlaces: 2,
              validator: (value) => validateDecimal(value),
              stateProvider: learningRateBoostProvider,
            ),
            configWidgetSpace,
            NumberField(
              label: 'Threads:',
              key: const Key('boost_max_depth'),
              tooltip: '''

              Number of threads to use for parallel processing; higher values can speed up training.

              ''',
              enabled: algorithm == 'Extreme',
              controller: _boostThreadsController,
              inputFormatter: FilteringTextInputFormatter.digitsOnly,
              validator: (value) => validateInteger(value, min: 1),
              stateProvider: threadsBoostProvider,
            ),
            configWidgetSpace,
            NumberField(
              label: 'Iterations:',
              key: const Key('boost_iteration'),
              tooltip: '''
  
              Number of boosting rounds or iterations to train the model.

              ''',
              enabled: algorithm == 'Extreme',
              controller: _boostIterationsController,
              inputFormatter: FilteringTextInputFormatter.digitsOnly,
              validator: (value) => validateInteger(value, min: 1),
              stateProvider: iterationsBoostProvider,
            ),
            configWidgetSpace,
            variableChooser(
              'Objective',
              modelObjective,
              objective,
              ref,
              objectiveBoostProvider,
              enabled: algorithm == 'Extreme',
              onChanged: (String? value) {
                if (value != null) {
                  ref.read(objectiveBoostProvider.notifier).state = value;
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
