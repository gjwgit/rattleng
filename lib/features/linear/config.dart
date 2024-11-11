/// Widget to configure the LINEAR tab: button.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Thursday 2024-06-13 17:05:58 +1000 Graham Williams>
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
import 'package:rattle/constants/style.dart';
import 'package:rattle/providers/linear.dart';
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/utils/get_target.dart';
import 'package:rattle/widgets/activity_button.dart';
import 'package:rattle/widgets/choice_chip_tip.dart';

/// The LINEAR tab config currently consists of just an ACTIVITY button.
///
/// This is a StatefulWidget to pass the ref across to the rSource.

class LinearConfig extends ConsumerStatefulWidget {
  const LinearConfig({super.key});

  @override
  ConsumerState<LinearConfig> createState() => LinearConfigState();
}

class LinearConfigState extends ConsumerState<LinearConfig> {
  Map<String, String> linearFamily = {
    'Logit': '''

        The logit model uses the logistic function to model the probability of a binary outcome, 
        mapping it to a log-odds scale for linearity in coefficients.
    
    ''',
    'Probit': '''
        
        The probit model uses the cumulative normal distribution to model the probability of 
        a binary outcome, mapping probabilities to a z-score scale for linearity in coefficients.
    
    ''',
  };

  @override
  Widget build(BuildContext context) {
    String family = ref.read(familyLinearProvider);

    return Column(
      children: [
        // Space above the beginning of the configs.

        const SizedBox(height: 5),

        Row(
          children: [
            // Space to the left of the configs.

            const SizedBox(width: 5),

            // The BUILD button.

            ActivityButton(
              onPressed: () async {
                await rSource(
                  context,
                  ref,
                  ['model_template', 'model_build_linear'],
                );
                await ref.read(linearPageControllerProvider).animateToPage(
                      // Index of the second page.
                      1,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
              },
              child: const Text('Build Linear Model'),
            ),
            configWidgetGap,
            Text('Target: ${getTarget(ref)}'),
            configWidgetGap,
            const Text(
              'Family:',
              style: normalTextStyle,
            ),
            configWidgetGap,
            ChoiceChipTip<String>(
              options: linearFamily.keys.toList(),
              selectedOption: family,
              tooltips: linearFamily,
              onSelected: (chosen) {
                setState(() {
                  if (chosen != null) {
                    family = chosen;
                    ref.read(familyLinearProvider.notifier).state = chosen;
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
