/// Widget to configure the SVM tab: button.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Thursday 2024-06-13 17:05:36 +1000 Graham Williams>
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
import 'package:rattle/providers/evaluate.dart';
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/providers/svm.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/utils/get_target.dart';
import 'package:rattle/utils/variable_chooser.dart';
import 'package:rattle/widgets/activity_button.dart';
import 'package:rattle/widgets/number_field.dart';

/// Kernel setting of SVM.

List<String> svmKernel = [
  'Radial Basis (rbfdot)',
  'Polynomial (polydot)',
  'Linear (vanilladot)',
  'Hyperbolic Tangent (tanhdot)',
  'Laplacian (laplacedot)',
  'Bessel (besseldot)',
  'ANOVA RBF (anovadot)',
  'Spline (splinedot)',
];

/// The SVM tab config currently consists of just an ACTIVITY button.
///
/// This is a StatefulWidget to pass the ref across to the rSource.

class SvmConfig extends ConsumerStatefulWidget {
  const SvmConfig({super.key});

  @override
  ConsumerState<SvmConfig> createState() => SvmConfigState();
}

class SvmConfigState extends ConsumerState<SvmConfig> {
  final TextEditingController _svmDegreeController = TextEditingController();

  @override
  void dispose() {
    // Dispose the controllers to free up resources.

    _svmDegreeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String kernel = ref.read(kernelSVMProvider.notifier).state;

    return Column(
      children: [
        // Space above the beginning of the configs.

        configTopGap,

        Row(
          children: [
            // Space to the left of the configs.

            configLeftGap,

            // The BUILD button.

            ActivityButton(
              onPressed: () async {
                // Run the R scripts.

                String mt = 'model_template';
                String mbs = 'model_build_svm';
                String etr = 'evaluate_template_tr';
                String etu = 'evaluate_template_tu';
                String erc = 'evaluate_riskchart';

                await rSource(context, ref, [mt, mbs, etr, erc, etu, erc]);

                ref.read(svmEvaluateProvider.notifier).state = true;

                await ref.read(svmPageControllerProvider).animateToPage(
                      // Index of the second page.
                      1,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
              },
              child: const Text('Build SVM Model'),
            ),

            configWidgetGap,

            Text('Target: ${getTarget(ref)}'),

            configWidgetGap,

            variableChooser(
              'Kernel:',
              svmKernel,
              kernel,
              ref,
              kernelSVMProvider,
              tooltip: '''

              A mathematical function that transforms data into a higher-dimensional space, 
              enabling the model to find a more effective boundary between classes.

              ''',
              enabled: true,
              onChanged: (String? value) {
                setState(() {
                  if (value != null) {
                    ref.read(kernelSVMProvider.notifier).state = value;
                  }
                });
              },
            ),

            configWidgetGap,

            NumberField(
              label: 'Degree:',
              key: const Key('svm_degree'),
              tooltip: '''

              Controls the complexity of the polynomial decision boundary, 
              with higher degrees allowing more complex relationships.

              ''',
              enabled: kernel == svmKernel[1],
              controller: _svmDegreeController,
              inputFormatter: FilteringTextInputFormatter.digitsOnly,
              validator: (value) => validateInteger(value, min: 1),
              stateProvider: degreeSVMProvider,
            ),
          ],
        ),
      ],
    );
  }
}
