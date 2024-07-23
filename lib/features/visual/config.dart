/// Widget to configure the VISUAL tab: button.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Tuesday 2024-07-23 10:03:40 +1000 Graham Williams>
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

import 'package:rattle/providers/stdout.dart';
import 'package:rattle/providers/selected.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/r/extract.dart';
import 'package:rattle/widgets/activity_button.dart';
import 'package:rattle/utils/get_inputs.dart';
import 'package:rattle/utils/get_target.dart';
import 'package:rattle/utils/show_ok.dart';

/// The VISUAL tab config currently consists of just a BUILD button.
///
/// This is a StatefulWidget to pass the ref across to the rSource.

class VisualConfig extends ConsumerStatefulWidget {
  const VisualConfig({super.key});

  @override
  ConsumerState<VisualConfig> createState() => VisualConfigState();
}

class VisualConfigState extends ConsumerState<VisualConfig> {
  @override
  Widget build(BuildContext context) {
    String stdout = ref.watch(stdoutProvider);

    // Retireve the list of inputs as the label and value of the dropdown menu.

    List<String> inputs = getInputs(ref);

    // Retrieve the current selected variable and use that as the initial value
    // for the dropdown menu. If there is no current value then we choose the
    // first input variable.

    String selected = ref.read(selectedProvider.notifier).state;
    if (selected == 'NULL') {
      selected = inputs.first;
      // This causes an exception.... Really want to initialise.
      // ref.read(selectedProvider.notifier).state = selected;
    }

    // BUILD button action.

    void build() {
      // Business Rules for Building a Tree

      // Require a target variable which is used to categorise the
      // plots.

      String target = getTarget(ref);

      if (target == 'NULL') {
        showOk(
          context: context,
          title: 'No Target Specified',
          content: '''

                    Please choose a variable from amongst those variables in the
                    dataset as the **Target**. This will be used to visualise
                    the selected **Risk** variable against the target
                    outcomes/categories. Within some of the visualisations you
                    can then see its relationship with the risk variable that
                    you have under review. You can choose the target variable
                    from the **Dataset** tab **Roles** feature.

                    ''',
        );
      } else {
        // Run the R scripts.

        // Choose which visualisations to run depending on the
        // selected variable.

        String numc = rExtract(stdout, '+ numc');
        if (numc.contains('"$selected"')) {
          rSource(context, ref, 'explore_visual_numeric');
        } else {
          rSource(context, ref, 'explore_visual_categoric');
        }
      }
    }

    return Column(
      children: [
        // Space above the beginning of the configs.

        const SizedBox(height: 10),

        Row(
          children: [
            // Space to the left of the configs.

            const SizedBox(width: 5),

            // The BUILD button.

            ActivityButton(
              onPressed: () {
                build();
              },
              child: const Text('Visualise'),
            ),
            const SizedBox(width: 20.0),

            Expanded(
              child: DropdownMenu(
                label: const Text('Input'),
                initialSelection: selected,
                dropdownMenuEntries: inputs.map((s) {
                  return DropdownMenuEntry(value: s, label: s);
                }).toList(),
                // On selection as well as recording what was selected rebuild the
                // visualisations.
                onSelected: (String? value) {
                  ref.read(selectedProvider.notifier).state =
                      value ?? 'IMPOSSIBLE';
                  build();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
