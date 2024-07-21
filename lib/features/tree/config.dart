/// Widget to configure the tree tab with a button to build the tree.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Sunday 2024-07-21 16:15:16 +1000 Graham Williams>
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
/// Authors: Graham Williams, Yixiang Yin

library;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/r/source.dart';
import 'package:rattle/widgets/activity_button.dart';
import 'package:rattle/utils/get_target.dart';
import 'package:rattle/utils/show_ok.dart';

/// The tree tab config currently consists of just a BUILD button.
///
/// This is a StatefulWidget to pass the ref across to the rSouorce.

class TreeConfig extends ConsumerStatefulWidget {
  const TreeConfig({super.key});

  @override
  ConsumerState<TreeConfig> createState() => TreeConfigState();
}

class TreeConfigState extends ConsumerState<TreeConfig> {
  @override
  Widget build(BuildContext context) {
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
              onPressed: () {
                // Business Rules for Building a Tree

                // Require a target variable.

                if (getTarget(ref) == 'NULL') {
                  showOk(
                    context: context,
                    title: 'No Target Specified',
                    content: '''

                    There is no target variable identified.  Please choose a
                    variable as the target for the model from the **Dataset**
                    tab.

                    ''',
                  );
                } else {
                  // Run the R scripts.

                  rSource(context, ref, 'model_template');
                  rSource(context, ref, 'model_build_rpart');
                }
                // TODO yyx 20240627 How should I restore this effect in the new Widget Pages?
                // it failed to work only when user first click build on the panel because the pages are not yet updated.
                // treePagesKey.currentState?.goToResultPage();
              },
              child: const Text('Build Decision Tree'),
            ),
          ],
        ),
      ],
    );
  }
}
