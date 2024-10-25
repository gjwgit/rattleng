/// Widget to configure the SUMMARY tab with a button to generate the summary.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Thursday 2024-10-24 15:38:15 +1100 Graham Williams>
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
import 'package:rattle/providers/summary_crosstab.dart';
import 'package:rattle/providers/page_controller.dart';

import 'package:rattle/constants/spacing.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/widgets/activity_button.dart';
import 'package:rattle/widgets/labelled_checkbox.dart';

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

    ref.watch(crossTabSummaryProvider);

    return Column(
      children: [
        configTopSpace,
        Row(
          children: [
            configLeftSpace,
            // The "Generate Dataset Summary" button.
            ActivityButton(
              tooltip: '''

              Tap to request R to generate a few summaries of the dataset.

              ''',
              pageControllerProvider: summaryPageControllerProvider,
              onPressed: () {
                rSource(context, ref, ['explore_summary']);
              },
              child: const Text('Generate Dataset Summary'),
            ),
            configWidgetSpace,
            LabelledCheckbox(
              label: 'Include Cross Tab',
              tooltip: '''

              Enable the generation of a cross-tabulation summary. Note that
              this can be quite time consuming and using considerable amount of
              memory. By default the option is disabled. Enable it here to
              obtain the cross tabulation summary.

              ''',
              provider: crossTabSummaryProvider,
              enabled: true,
            ),
          ],
        ),
      ],
    );
  }
}
