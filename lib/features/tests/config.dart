/// Widget to configure the TESTS tab: button.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Monday 2024-10-07 06:38:54 +1100 Graham Williams>
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
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/providers/selected.dart';
import 'package:rattle/providers/selected2.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/utils/get_numeric.dart';
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
    // Update the rolesProvider to get the latest inputs

    updateVariablesProvider(ref);

    // Retrieve numeric inputs for both dropdowns

    List<String> numericInputs = getNumeric(ref);

    // Set default selections for dropdowns if not yet selected

    String selected = ref.watch(selectedProvider);
    if (selected == 'NULL' && numericInputs.isNotEmpty) {
      selected = numericInputs.first;
    }

    String selected2 = ref.watch(selected2Provider);
    if (selected2 == 'NULL' && numericInputs.length > 1) {
      selected2 = numericInputs[1];
    }

    return Column(
      children: [
        configTopGap,
        Row(
          children: [
            configLeftGap,

            // The BUILD button

            ActivityButton(
              pageControllerProvider:
                  testsPageControllerProvider, // Optional navigation

              onPressed: () {
                ref.read(selectedProvider.notifier).state = selected;
                ref.read(selected2Provider.notifier).state = selected2;
                rSource(context, ref, ['test']);
              },
              child: const Text('Perform Statistical Tests'),
            ),

            configWidgetGap,

            // Dropdown for first numeric input

            DropdownMenu(
              label: const Text('Input (Numeric)'),
              initialSelection: selected,
              dropdownMenuEntries: numericInputs.map((s) {
                return DropdownMenuEntry(value: s, label: s);
              }).toList(),
              onSelected: (String? value) {
                ref.read(selectedProvider.notifier).state =
                    value ?? 'IMPOSSIBLE';
              },
            ),

            configWidgetGap,

            // Dropdown for second numeric input

            DropdownMenu(
              label: const Text('Second (Numeric)'),
              initialSelection: selected2,
              dropdownMenuEntries: numericInputs.map((s) {
                return DropdownMenuEntry(value: s, label: s);
              }).toList(),
              onSelected: (String? value) {
                ref.read(selected2Provider.notifier).state =
                    value ?? 'IMPOSSIBLE';
              },
            ),
          ],
        ),
      ],
    );
  }
}
