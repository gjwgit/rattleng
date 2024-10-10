/// Widget to configure the SUMMARY tab with a button to generate the summary.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Saturday 2024-10-05 11:12:15 +1000 Graham Williams>
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
import 'package:rattle/providers/crosstab.dart';
import 'package:rattle/providers/page_controller.dart';

import 'package:rattle/r/source.dart';
import 'package:rattle/widgets/activity_button.dart';

/// The SUMMARY tab config currently consists of just a BUILD button.
///
/// This is a StatefulWidget to pass the ref across to the rSource.

class SummaryConfig extends ConsumerStatefulWidget {
  const SummaryConfig({super.key});

  @override
  ConsumerState<SummaryConfig> createState() => SummaryConfigState();
}

class SummaryConfigState extends ConsumerState<SummaryConfig> {
  @override
  Widget build(BuildContext context) {
    // Get the state of the "Include Cross Tab" checkbox from the provider.

    final includeCrossTab = ref.watch(includeCrossTabProvider);

    return Column(
      children: [
        const SizedBox(height: 5),
        Row(
          children: [
            const SizedBox(width: 5),

            // The "Generate Dataset Summary" button.
            ActivityButton(
              pageControllerProvider: summaryPageControllerProvider,
              onPressed: () {
                // Pass the "Include Cross Tab" selection to rSource.

                rSource(
                  context,
                  ref,
                  'explore_summary',
                  includeCrossTab: includeCrossTab,
                );
              },
              child: const Text('Generate Dataset Summary'),
            ),
            const SizedBox(width: 10),

            Checkbox(
              value: includeCrossTab,
              onChanged: (value) {
                // Update the state of the checkbox.

                ref.read(includeCrossTabProvider.notifier).state =
                    value ?? false;
              },
            ),
            const Text('Include Cross Tab'),
          ],
        ),
      ],
    );
  }
}
