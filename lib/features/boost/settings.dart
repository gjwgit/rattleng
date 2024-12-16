/// Boost settings for different boost algorithms.
///
/// Time-stamp: <Saturday 2024-12-14 21:25:32 +1100 Graham Williams>
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
/// Authors: Zheyuan Xu, Graham Williams

library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/spacing.dart';
import 'package:rattle/providers/boost.dart';
import 'package:rattle/utils/variable_chooser.dart';
import 'package:rattle/widgets/number_field.dart';

/// Objectives setting of XGBoost.

List<String> modelObjective = [
  'reg:squarederror',
  'reg:linear',
  'reg:logistic',
  'binary:logistic',
  'binary:logitraw',
];

class BoostSettings extends ConsumerStatefulWidget {
  final String algorithm;

  const BoostSettings({
    super.key,
    required this.algorithm,
  });

  @override
  ConsumerState<BoostSettings> createState() => _BoostSettingsState();
}

class _BoostSettingsState extends ConsumerState<BoostSettings> {
  // Controllers for the input fields.

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

    String objective = ref.read(objectiveBoostProvider.notifier).state;

    return Column(
      spacing: configRowSpace,
      children: [
        Row(
          spacing: configWidgetSpace,
          children: [
            configLeftGap,
            NumberField(
              label: 'Max Depth:',
              key: const Key('boost_max_depth'),
              tooltip: '''

              Maximum depth of each tree. This serves to control the model
              complexity. Be wary the deeper trees can also lead to the model
              over-fitting the training data and so a good general model.

              ''',
              max: 10,
              min: 5,
              controller: _boostMaxDepthController,
              inputFormatter: FilteringTextInputFormatter.digitsOnly,
              validator: (value) => validateInteger(value, min: 1),
              stateProvider: maxDepthBoostProvider,
            ),
            NumberField(
              label: 'Min Split:',
              key: const Key('boost_min_split'),
              tooltip: '''

              Minimum number of samples required to split an internal node.

              ''',
              enabled: widget.algorithm == 'Adaptive',
              controller: _boostMinSplitController,
              inputFormatter: FilteringTextInputFormatter.digitsOnly,
              validator: (value) => validateInteger(value, min: 1),
              stateProvider: minSplitBoostProvider,
            ),
            NumberField(
              label: 'Complexity:',
              key: const Key('boost_complexity'),
              tooltip: '''

              Regularization parameter that penalizes complex trees to prevent
              the model over-fitting the training data, and so not a good
              general model.

              ''',
              enabled: widget.algorithm == 'Adaptive',
              controller: _boostComplexityController,
              inputFormatter: FilteringTextInputFormatter.allow(
                RegExp(r'^[0-9]*\.?[0-9]{0,4}$'),
              ),
              interval: 0.0005,
              decimalPlaces: 4,
              validator: (value) => validateDecimal(value),
              stateProvider: complexityBoostProvider,
            ),
            NumberField(
              label: 'X Val:',
              key: const Key('boost_x_value'),
              tooltip: '''

              Number of folds in cross-validation. This provides an estimate of
              the model performance in general.

              ''',
              enabled: widget.algorithm == 'Adaptive',
              controller: _boostXValueController,
              inputFormatter: FilteringTextInputFormatter.digitsOnly,
              validator: (value) => validateInteger(value, min: 1),
              stateProvider: xValueBoostProvider,
            ),
          ],
        ),
        Row(
          spacing: configWidgetSpace,
          children: [
            configLeftGap,
            NumberField(
              label: 'Learning Rate:',
              key: const Key('boost_learning_rate'),
              tooltip: '''

              Step size at each iteration. Smaller values can lead to a more
              robust model but will take more time to train.

              ''',
              enabled: widget.algorithm == 'Extreme',
              controller: _boostLearningRateController,
              inputFormatter: FilteringTextInputFormatter.allow(
                RegExp(r'^[0-9]*\.?[0-9]{0,4}$'),
              ),
              interval: 0.05,
              decimalPlaces: 2,
              max: 1.0,
              min: 0.0,
              validator: (value) => validateDecimal(value),
              stateProvider: learningRateBoostProvider,
            ),
            NumberField(
              label: 'Threads:',
              key: const Key('boost_max_depth'),
              tooltip: '''

              Number of threads to use for parallel processing. Higher values
              can speed up training if you have multiple threads available on
              your CPU.

              ''',
              enabled: widget.algorithm == 'Extreme',
              controller: _boostThreadsController,
              inputFormatter: FilteringTextInputFormatter.digitsOnly,
              validator: (value) => validateInteger(value, min: 1),
              stateProvider: threadsBoostProvider,
            ),
            NumberField(
              label: 'Iterations:',
              key: const Key('boost_iteration'),
              tooltip: '''

              Number of boosting rounds or iterations to train the model. This
              is the number of trees that will be built for the ensemble.

              ''',
              controller: _boostIterationsController,
              inputFormatter: FilteringTextInputFormatter.digitsOnly,
              validator: (value) => validateInteger(value, min: 1),
              stateProvider: iterationsBoostProvider,
            ),
            variableChooser(
              'Objective',
              modelObjective,
              objective,
              ref,
              objectiveBoostProvider,
              tooltip: '''

              The objective is used to minimize a regularized loss function to
              achieve accurate predictions while preventing over-fitting.

              ''',
              enabled: widget.algorithm == 'Extreme',
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
