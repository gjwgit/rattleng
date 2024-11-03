/// Widget to configure the VISUAL tab: button.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Sunday 2024-09-22 05:58:34 +1000 Graham Williams>
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
import 'package:rattle/providers/group_by.dart';

import 'package:rattle/constants/spacing.dart';
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/providers/selected.dart';
import 'package:rattle/providers/vars/types.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/utils/get_catergoric.dart';
import 'package:rattle/utils/update_roles_provider.dart';
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
    // update the rolesProvider to get the latest inputs
    updateVariablesProvider(ref);

    // Retireve the list of inputs as the label and value of the dropdown menu.

    List<String> inputs = getInputs(ref);

    Map typeState = ref.read(typesProvider.notifier).state;

    // Sort the inputs list with numerical types first.
    inputs.sort((a, b) {
      final aType = typeState[a];
      final bType = typeState[b];

      if (aType == Type.numeric && bType != Type.numeric) {
        return -1;
      } else if (aType != Type.numeric && bType == Type.numeric) {
        return 1;
      } else {
        return 0;
      }
    });

    // Retrieve the current selected variable and use that as the initial value
    // for the dropdown menu. If there is no current value and we do have inputs
    // then we choose the first input variable.

    String selected = ref.watch(selectedProvider);
    if (selected == 'NULL' && inputs.isNotEmpty) {
      selected = inputs.first;
    }

    // Retrieve the categoric variables that will be used to group the
    // visualisations by. Be sure to also include the Target,

    List<String> cats = getCategoric(ref);

    String groupBy = ref.watch(groupByProvider);

    // By default, choose the target variable assume target exists.

    if (groupBy == 'NULL') {
      groupBy = getTarget(ref);
    }

    // BUILD Action.

    void buildAction() {
      // Business Logic for Building a Tree

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
        if (ref.read(typesProvider.notifier).state[selected] == Type.numeric) {
          rSource(context, ref, ['explore_visual_numeric']);
        } else {
          rSource(context, ref, ['explore_visual_categoric']);
        }
      }
    }

    return Column(
      children: [
        configTopGap,
        Row(
          children: [
            configLeftGap,

            // The BUILD button.
            ActivityButton(
              pageControllerProvider:
                  visualPageControllerProvider, // Optional navigation
              onPressed: () {
                // Had to update here because
                // Unhandled Exception: Tried to modify a provider while the widget tree was building.
                // If you are encountering this error, chances are you tried to modify a provider
                // in a widget life-cycle, such as but not limited to:
                // - build
                // - initState
                // - dispose
                // - didUpdateWidget
                // - didChangeDependencies

                // Modifying a provider inside those life-cycles is not allowed, as it could
                // lead to an inconsistent UI state. For example, two widgets could listen to the
                // same provider, but incorrectly receive different states.

                // To fix this problem, you have one of two solutions:
                // - (preferred) Move the logic for modifying your provider outside of a widget
                //   life-cycle. For example, maybe you could update your provider inside a button's
                //   onPressed instead.

                // - Delay your modification, such as by encapsulating the modification
                //   in a `Future(() {...})`.
                //   This will perform your update after the widget tree is done building
                ref.read(selectedProvider.notifier).state = selected;
                ref.read(groupByProvider.notifier).state = groupBy;

                buildAction();
              },
              child: const Text('Generate Plots'),
            ),

            configWidgetGap,

            DropdownMenu(
              label: const Text('Variable'),
              width: 200,
              initialSelection: selected,
              dropdownMenuEntries: inputs.map((s) {
                return DropdownMenuEntry(value: s, label: s);
              }).toList(),
              // On selection we record the variable that was selected AND we
              // rebuild the visualisations.
              onSelected: (String? value) {
                ref.read(selectedProvider.notifier).state =
                    value ?? 'IMPOSSIBLE';
                // NOT YET WORKING FIRST TIME buildAction();
              },
            ),

            configWidgetGap,

            DropdownMenu(
              label: const Text('Group by'),
              width: 200.0,
              initialSelection: groupBy,
              dropdownMenuEntries: cats.map((s) {
                return DropdownMenuEntry(value: s, label: s);
              }).toList(),
              // On selection we record the variable that was selected AND we
              // rebuild the visualisations.
              onSelected: (String? value) {
                ref.read(groupByProvider.notifier).state =
                    value ?? 'IMPOSSIBLE';
                // NOT YET WORKING FIRST TIME buildAction();
              },
            ),
          ],
        ),
      ],
    );
  }
}
