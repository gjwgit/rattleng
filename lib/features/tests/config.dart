/// Widget to configure the TESTS tab: button.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Wednesday 2024-07-31 21:32:38 +1000 Graham Williams>
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
import 'package:rattle/providers/selected.dart';
import 'package:rattle/providers/selected2.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/utils/get_inputs.dart';
import 'package:rattle/utils/update_roles_provider.dart';

import 'package:rattle/widgets/activity_button.dart';

/// The TESTS tab config currently consists of just a BUILD button.
///
/// This is a StatefulWidget to pass the ref across to the rSource.

class TestsConfig extends ConsumerStatefulWidget {
  const TestsConfig({super.key});

  @override
  ConsumerState<TestsConfig> createState() => TestsConfigState();
}

class TestsConfigState extends ConsumerState<TestsConfig> {
  @override
  Widget build(BuildContext context) {
    // update the rolesProvider to get the latest inputs
    updateRolesProvider(ref);
    // Retrieve the current selected variable and use that as the initial value
    // for the dropdown menu. If there is no current value then we choose the
    // first input variable.
    List<String> inputs = getInputs(ref);
    String selected = ref.watch(selectedProvider);
    if (selected == 'NULL' && inputs.isNotEmpty) {
      selected = inputs.first;
    }

    String selected2 = ref.watch(selected2Provider);
    if (selected2 == 'NULL' && inputs.isNotEmpty) {
      selected2 = inputs[1];
    }

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
                ref.read(selectedProvider.notifier).state = selected;
                ref.read(selected2Provider.notifier).state = selected2;
                rSource(context, ref, 'test');
                // showUnderConstruction(context);
              },
              child: const Text('Run Tests'),
            ),
            const SizedBox(
              width: 10,
            ),
            DropdownMenu(
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
                // build();
              },
            ),
            const SizedBox(
              width: 10,
            ),
            DropdownMenu(
              label: const Text('Second'),
              initialSelection: selected2,
              dropdownMenuEntries: inputs.map((s) {
                return DropdownMenuEntry(value: s, label: s);
              }).toList(),
              // On selection as well as recording what was selected rebuild the
              // visualisations.
              onSelected: (String? value) {
                ref.read(selected2Provider.notifier).state =
                    value ?? 'IMPOSSIBLE';
                // build();
              },
            ),
          ],
        ),
      ],
    );
  }
}
