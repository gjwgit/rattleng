/// Widget to configure the BOOST tab: button.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Thursday 2024-06-13 17:06:23 +1000 Graham Williams>
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
import 'package:rattle/features/boost/boost_setting.dart';
import 'package:rattle/providers/boost.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/widgets/activity_button.dart';
import 'package:rattle/widgets/choice_chip_tip.dart';

/// The BOOST tab config currently consists of just an ACTIVITY button.
///
/// This is a StatefulWidget to pass the ref across to the rSource.

class BoostConfig extends ConsumerStatefulWidget {
  const BoostConfig({super.key});

  @override
  ConsumerState<BoostConfig> createState() => BoostConfigState();
}

class BoostConfigState extends ConsumerState<BoostConfig> {
  Map<String, String> boostAlgorithm = {
    'Extreme': '''

      A highly efficient gradient boosting algorithm designed for large-scale 
      and complex data.

      ''',
    'Adaptive': '''

      A boosting algorithm that builds a strong classifier by iteratively 
      combining weak learners, focusing on errors.

      ''',
  };

  @override
  Widget build(BuildContext context) {
    String algorithm = ref.read(algorithmBoostProvider.notifier).state;

    return Column(
      children: [
        // Space above the beginning of the configs.

        const SizedBox(height: 5),

        Row(
          children: [
            // Space to the left of the configs.

            configLeftSpace,

            // The BUILD button.

            ActivityButton(
              onPressed: () async {
                await rSource(context, ref, 'model_template');
                if (algorithm == 'Extreme') {
                  await rSource(context, ref, 'model_build_xgboost');
                } else if (algorithm == 'Adaptive') {
                  await rSource(context, ref, 'model_build_adaboost');
                }
              },
              child: const Text('Build Boosted Trees'),
            ),

            configWidgetSpace,

            const Text(
              'Algorithm:',
              style: normalTextStyle,
            ),

            configWidgetSpace,

            ChoiceChipTip<String>(
              options: boostAlgorithm.keys.toList(),
              selectedOption: algorithm,
              tooltips: boostAlgorithm,
              onSelected: (chosen) {
                setState(() {
                  if (chosen != null) {
                    algorithm = chosen;
                    ref.read(algorithmBoostProvider.notifier).state = chosen;
                  }
                });
              },
            ),
          ],
        ),
        BoostSetting(algorithm: algorithm),
      ],
    );
  }
}
