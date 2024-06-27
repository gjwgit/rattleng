/// Widget to configure the tree tab: button.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Wednesday 2024-06-12 12:10:31 +1000 Graham Williams>
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
import 'package:rattle/panels/tree/panel.dart';

import 'package:rattle/r/source.dart';
import 'package:rattle/widgets/activity_button.dart';

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
                debugPrint('TREE CONFIG BUTTON');
                rSource(context, ref, 'model_template');
                rSource(context, ref, 'model_build_rpart');
                // TODO yyx 20240627 How should I restore this effect in the new Widget Pages?
                // it failed to work only when user first click build on the panel because the pages are not yet updated.
                treePagesKey.currentState?.goToResultPage();
              },
              child: const Text('Build Decision Tree'),
            ),
          ],
        ),
      ],
    );
  }
}
