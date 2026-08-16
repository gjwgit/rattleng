/// The LOAD DATASET button of the EVALUATE tab.
///
/// Time-stamp: "Sunday 2026-08-16 11:05:00 +1000 Graham Williams"
///
/// Copyright (C) 2026, Togaware Pty Ltd.
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://opensource.org/license/gpl-3-0
///
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
// this program.  If not, see <https://opensource.org/license/gpl-3-0>.
///
/// Authors: Graham Williams

library;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';

import 'package:rattle/features/dataset/file_folder_picker.dart';
import 'package:rattle/providers/evaluate.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/utils/wait_for_r_output.dart';

/// Load a dataset from file to evaluate the model against.
///
/// The file is prepared by `evaluate_load_dataset.R` to match the dataset the
/// model was trained on, and the **Loaded** evaluation dataset is then selected
/// so that the next Evaluate uses it.

class LoadDatasetButton extends ConsumerWidget {
  const LoadDatasetButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MarkdownTooltip(
      message: '''

      **Load Dataset**

      Tap here to browse to a **csv** file of observations to evaluate the model
      against, rather than evaluating over a partition of the dataset the model
      was built from. Observations the model has never seen give the most honest
      estimate of how it will perform in use.

      The file needs the same variables, named the same way, as the dataset the
      model was built from, including the **target** variable, which is what the
      predictions are measured against. Anything missing is reported in the
      **Console**.

      Once loaded, the **Loaded** evaluation dataset is selected for you.

      ''',
      child: ElevatedButton(
        onPressed: () async {
          final String path = await datasetSelectFile();

          if (path.isEmpty || !context.mounted) return;

          ref.read(evaluateDatasetPathProvider.notifier).state = path;

          final int from = ref.read(stdoutProvider).length;

          await rSource(context, ref, ['evaluate_load_dataset']);

          // Note whether the dataset has the target variable, which decides
          // whether it can be evaluated or only scored.

          final String reported = await waitForROutput(
            ref,
            '> rat(evalds_has_target, "\\n")',
            from: from,
          );

          ref.read(evaluateDatasetHasTargetProvider.notifier).state =
              reported.trim().contains('TRUE');

          // Choose it as the evaluation dataset, which is why the user loaded
          // it, rather than leaving them to also tap the chip.

          ref.read(datasetTypeProvider.notifier).state = 'Loaded';
        },
        child: const Text('Load Dataset'),
      ),
    );
  }
}
