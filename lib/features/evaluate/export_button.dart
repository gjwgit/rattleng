/// The EXPORT button of the EVALUATE tab.
///
/// Time-stamp: "Sunday 2026-08-16 12:30:00 +1000 Graham Williams"
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

import 'package:rattle/features/evaluate/activity_button.dart';
import 'package:rattle/features/evaluate/model_scripts.dart';
import 'package:rattle/providers/evaluate.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/utils/select_file.dart';

/// Export the evaluation results as a CSV file, one row per observation.
///
/// The one file carries the observations, the actual outcome once, and then a
/// predicted column, and a probability where there is one, for each ticked
/// model. Having every model's view of the very same observation on the one row
/// is what makes the models comparable.

class ExportButton extends ConsumerWidget {
  const ExportButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<String> scripts = evaluateModelScripts(ref);
    final bool enabled = scripts.isNotEmpty;

    return MarkdownTooltip(
      message: '''

      **Export**

      Tap here to save the evaluation results to a **csv** file: a row for each
      observation of the evaluation dataset, being the observation itself, the
      **actual** value once, then what each model **predicted** and the
      **probability** it gave. Every measure reported here can be recomputed
      from it, and the rows where actual and predicted differ are the ones the
      model got wrong.

      Each model you have ticked adds its own **predicted** column, named for
      the model, so the one file compares them over the very same
      observations.${enabled ? '' : '''


      You will need to tick a model above before there is anything to
      export.'''}

      ''',
      child: ElevatedButton(
        onPressed: enabled
            ? () async {
                final String? path = await selectFile(
                  defaultFileName: 'evaluate.csv',
                  allowedExtensions: const ['csv'],
                );

                if (path == null || path.isEmpty) return;

                ref.read(evaluateExportPathProvider.notifier).state = path;

                final String datasetType = ref.read(datasetTypeProvider);

                // Each model adds its columns to the one table, which the
                // first of them starts, and which is written out at the end.
                // Let [executeEvaluation] choose the template for the
                // evaluation dataset, as it does for the measures, so that the
                // export always matches what was evaluated.

                for (final String script in scripts) {
                  if (!context.mounted) return;

                  await executeEvaluation(
                    executed: true,
                    parameters: [
                      script,
                      if (script == scripts.first) 'evaluate_export_start',
                      'evaluate_export_model',
                    ],
                    datasetSplitType: datasetType,
                    context: context,
                    ref: ref,
                  );
                }

                if (!context.mounted) return;

                await rSource(context, ref, ['evaluate_export_write']);
              }
            : null,
        child: const Text('Export'),
      ),
    );
  }
}
