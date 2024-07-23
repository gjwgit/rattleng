/// Widget to configure the VISUAL tab: button.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Monday 2024-07-22 08:36:28 +1000 Graham Williams>
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
import 'package:rattle/providers/roles.dart';

import 'package:rattle/providers/stdout.dart';
import 'package:rattle/providers/variable_selection.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/r/extract.dart';
import 'package:rattle/widgets/activity_button.dart';
import 'package:rattle/utils/get_risk.dart';
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
    List<String> vars = ref.watch(rolesProvider).keys.toList();

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

                // Require a risk and target variable.

                String risk = getRisk(ref);
                String target = getTarget(ref);

                if (risk == 'NULL' && target == 'NULL') {
                  showOk(
                    context: context,
                    title: 'No Risk or Target Variable Specified',
                    content: '''

                    Please choose a variable from amongst those variables in the
                    dataset as the **Risk** variable and anopther as the
                    **Target** variable. The risk variable will be the variable
                    that we will visualise here. The selected risk variable will
                    be reviewed against the target variable
                    outcomes/categories. Within some of the visualisations you
                    will then see any relationship between the risk variable
                    under review and the target variable. You can choose the
                    risk and target variables from the **Dataset** tab **Roles**
                    feature.

                    ''',
                  );
                } else if (risk == 'NULL') {
                  showOk(
                    context: context,
                    title: 'No Risk Variable Specified',
                    content: '''

                    Please choose a variable from amongst those variables in the
                    dataset as the **Risk** variable. This will be the variable
                    that we will visualise here. The selected risk variable will
                    be reviewed against the target outcomes/categories. Within
                    some of the visualisations you will then see any
                    relationship between the risk variable under review and the
                    target variable. You can choose the risk variable from the
                    **Dataset** tab **Roles** feature.

                    ''',
                  );
                } else if (target == 'NULL') {
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
                  if (numc.contains('"$risk"')) {
                    rSource(context, ref, 'explore_visual_numeric');
                  } else {
                    rSource(context, ref, 'explore_visual_categoric');
                  }
                }
              },
              child: const Text('Display'),
            ),
            const SizedBox(width: 20.0),
            const Text(
              'R packages like ggplot are utilised to build a variety of charts, plots, and graphs.',
            ),
            const SizedBox(width: 20.0),
            Expanded(
              child: DropdownMenu(
                label: const Text('Variable Selection'),
                initialSelection: vars.first,
                dropdownMenuEntries: vars.map((s) {
                  return DropdownMenuEntry(value: s, label: s);
                }).toList(),
                onSelected: (String? value) {
                  ref.read(varProvider.notifier).state = value!;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
