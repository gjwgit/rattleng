/// A popup with choices for sourcing the dataset.
///
/// Time-stamp: <Friday 2024-12-13 15:55:29 +1100 Graham Williams>
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
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
// this program.  If not, see <https://www.gnu.org/licenses/>.
///
/// Authors: Graham Williams, Yiming Lu

library;

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';

import 'package:rattle/constants/spacing.dart';
import 'package:rattle/constants/status.dart';
import 'package:rattle/features/dataset/select_file.dart';
import 'package:rattle/providers/dataset_loaded.dart';
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/providers/path.dart';
import 'package:rattle/r/load_dataset.dart';
import 'package:rattle/utils/set_status.dart';
import 'package:rattle/utils/copy_asset_to_tempdir.dart';

void datasetLoadedUpdate(WidgetRef ref) {
  ref.read(datasetLoaded.notifier).state = true;
}

class DatasetPopup extends ConsumerWidget {
  const DatasetPopup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 20240809 gjw Delay the rStart() until we begin to load the dataset. This
    // may solve the Windows zip install issue whereby main.R is not being
    // loaded on startup yet the remainder of the R code does get loaded. Also,
    // we load it here rather than in rLoadDataset because at this time the user
    // is paused looking at the popup to load the dataset and we have time to
    // squeeze in and async run main.R before we get the `glimpse` missing
    // error.
    //
    // 20240809 gjw Revert for now until find the proper solution.
    //
    // 20240809 gjw Moved main.R into dataset_prep.R see if that works.

    // rStart(context, ref);

    // A state to hold the selected demo dataset.

    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            children: [
              Icon(
                Icons.data_usage,
                size: 24,
                color: Colors.blue,
              ),
              popupIconGap,
              Text(
                'Choose the Dataset Source:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          popupTitleGap,

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // FILENAME

              ElevatedButton(
                onPressed: () async {
                  String path = await datasetSelectFile();
                  if (path.isNotEmpty) {
                    ref.read(pathProvider.notifier).state = path;
                    if (context.mounted) await rLoadDataset(context, ref);
                    setStatus(ref, statusChooseVariableRoles);
                    datasetLoadedUpdate(ref);
                  }

                  // Avoid the "Do not use BuildContexts across async gaps."
                  // warning.

                  if (!context.mounted) return;
                  Navigator.pop(context, 'Filename');

                  // Access the PageController via Riverpod and move to the second page.

                  ref.read(pageControllerProvider).animateToPage(
                        // Index of the second page.

                        1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                },
                child: const MarkdownTooltip(
                  message: '''

                  **Filename for Dataset** Tap here to popup a window to browse
                  to a **csv** or **txt** file that you would like to load
                  into Rattle.

                  ''',
                  child: Text('Filename'),
                ),
              ),

              buttonGap,

              ElevatedButton(
                onPressed: null,
                // onPressed: () {
                //   // TODO 20231018 gjw datasetSelectPackage();
                //   Navigator.pop(context, 'Package');
                //   showUnderConstruction(context);
                //   datasetLoadedUpdate(ref);
                // },
                child: const MarkdownTooltip(
                  message: '''

                  **Under Development** Eventually you will be able to tap here
                  to popup a window to browse the list of available R datasets
                  to choose one of them to load into Rattle.

                  ''',
                  child: Text('Package'),
                ),
              ),
            ],
          ),

          configRowGap,

          const MarkdownTooltip(
            message: '''

                  **Demo Datasets** Rattle provides a number of small datasets
                  so you can very quickly explore the Rattle functionality.  The
                  *buttons* below will load one of the demo datasets. Hover over
                  any of them to see a description of that dataset.

                  ''',
            child: MarkdownBody(
              data: '**Demo Datasets** '
                  'Tap to load one of the available demonstration datasets:',
            ),
          ),

          configRowGap,

          //  Buttons for selecting the demo dataset.

          Consumer(
            builder: (context, ref, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buttonGap,
                  MarkdownTooltip(
                    message: '''

                      The **Weather** dataset is a recent dataset of one year of
                      daily observations from a weather station in Canberra,
                      Australia. It is useful to demonstrate all steps of the
                      Data Science process, to Explore, Transform, model, and
                      Evaluate. The target variable for predictive modelling is
                      the variable *Rain Tomorrow*. The amount of rain tomorrow
                      is recored as the variable *Risk MM*. Most of the
                      remaining variables could be used as inputs for building a
                      model to predict the likelihood of it raining tomorrow -
                      *should you take an umbrella with you tomorrow?*

                      The data has been collected from the Australian Bureau of
                      Meterology since 2007, covering over 50 weather stations
                      across Australia. The larger dataset is available from
                      Togaware as
                      [weatherAus.csv](https://access.togaware.com/weatherAUS.csv).

                      ''',
                    child: ElevatedButton(
                      onPressed: () async {
                        await loadDemoDataset(
                          ref,
                          context,
                          'data/weather.csv',
                          'Weather',
                        );
                      },
                      child: const Text('Weather'),
                    ),
                  ),
                  buttonGap,
                  MarkdownTooltip(
                    message: '''

                      The **Audit** dataset is a demonstrator for predicting
                      whether the govenrment revenue authority might need to
                      audit a taxpayer. The dataset of 2,000 fictional tax
                      payers who have previously been audited includes their
                      demographics and financial variables. The target variable
                      *Adjusted* records whether their financial data had to be
                      adjusted because their originally submitted data had
                      errors affting their tax obligation. The variable
                      *Adjustment* is the dollar amount of the adjustment - the
                      adjustment to their tax liability.

                      The resulting predictive model could be used to predict
                      the likelihood of an audit of a tax payer resulting in an
                      adjustment. Auditors can thus not waste their time on
                      non-productive audits.

                      ''',
                    child: ElevatedButton(
                      onPressed: () async {
                        await loadDemoDataset(
                          ref,
                          context,
                          'data/audit.csv',
                          'Audit',
                        );
                      },
                      child: const Text('Audit'),
                    ),
                  ),
                  buttonGap,
                  MarkdownTooltip(
                    message: '''

                      The **Protein** dataset comes from the [Tippie College of
                      Business, The University of
                      Iowa](http://www.biz.uiowa.edu/faculty/jledolter/DataMining/protein.csv). It
                      is useful for demonstrating **Cluster** analysis.

                      ''',
                    child: ElevatedButton(
                      onPressed: () async {
                        await loadDemoDataset(
                          ref,
                          context,
                          'data/protein.csv',
                          'Protein',
                        );
                      },
                      child: const Text('Protein'),
                    ),
                  ),
                  buttonGap,
                  MarkdownTooltip(
                    message: '''

                      The **Movies** dataset is useful for demonstrating basket
                      analysis under the **Associations** feature of the
                      **Model** tab. The dataset has just two
                      columns/variables. Each basket is uniquley identified and
                      each basket can contain 1 or more items. Running the
                      association rules analysis with *Baskets* enabled will
                      build assoitation rules found in the dataset.

                      ''',
                    child: ElevatedButton(
                      onPressed: () async {
                        await loadDemoDataset(
                          ref,
                          context,
                          'data/movies.csv',
                          'Movies',
                        );
                      },
                      child: const Text('Movies'),
                    ),
                  ),
                  buttonGap,
                  MarkdownTooltip(
                    message: '''

                      The **Sherlock** data file is a text file for
                      demonstrating the **Word Cloud** feature of the **Model**
                      tab. It is a snippet from a Sherlock Holmes novel.

                      ''',
                    child: ElevatedButton(
                      onPressed: () async {
                        await loadDemoDataset(
                          ref,
                          context,
                          'data/sherlock.txt',
                          'Sherlock',
                        );
                      },
                      child: const Text('Sherlock'),
                    ),
                  ),
                ],
              );
            },
          ),

          // SPACE between row of options and the cancel button.

          configRowGap,

          // Add a CANCEL button to do nothing but return.

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, 'Cancel');
                },
                child: const MarkdownTooltip(
                  message: '''

                  **Cancel** Tap here to **not** proceed with loading a new
                    dataset.

                  ''',
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> loadDemoDataset(
  WidgetRef ref,
  BuildContext context,
  String assetPath,
  String datasetName,
) async {
  // Copy the asset to a temporary directory.

  String dest = await copyAssetToTempDir(asset: assetPath);

  // Update the path provider state with the dataset path.

  ref.read(pathProvider.notifier).state = dest;

  // Check if the context is still mounted before proceeding and load the dataset.

  if (context.mounted) await rLoadDataset(context, ref);

  // Update the status to indicate variable roles can now be chosen.

  setStatus(ref, statusChooseVariableRoles);

  // Close the current dialog if the context is still mounted.

  if (context.mounted) Navigator.pop(context, datasetName);

  // Mark the dataset as loaded in the state management system.

  datasetLoadedUpdate(ref);

  // Navigate to the second page using the page controller.

  ref.read(pageControllerProvider).animateToPage(
        1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
}
