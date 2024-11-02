/// A popup with choices for sourcing the dataset.
///
/// Time-stamp: <Saturday 2024-11-02 10:53:30 +1100 Graham Williams>
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

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:rattle/constants/spacing.dart';
import 'package:rattle/constants/status.dart';
import 'package:rattle/features/dataset/select_file.dart';
import 'package:rattle/providers/dataset_loaded.dart';
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/providers/path.dart';
import 'package:rattle/r/load_dataset.dart';
import 'package:rattle/utils/set_status.dart';
import 'package:rattle/utils/show_under_construction.dart';
import 'package:rattle/utils/copy_asset_to_tempdir.dart';

const double heightSpace = 20;
const double widthSpace = 10;

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

              // Space between icon and title.

              SizedBox(width: widthSpace),

              Text(
                'Choose the Dataset Source:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          // Space between title and buttons.

          configRowGap,

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
                child: const Text('Filename'),
              ),

              // SPACE

              const SizedBox(width: widthSpace),

              // PACKAGE - Remove for now but include once implemented.

              ElevatedButton(
                onPressed: () {
                  // TODO 20231018 gjw datasetSelectPackage();
                  Navigator.pop(context, 'Package');
                  showUnderConstruction(context);
                  datasetLoadedUpdate(ref);
                },
                child: const Text('Package'),
              ),

              // SPACE

              const SizedBox(width: widthSpace),

              // DEMO
              ElevatedButton(
                onPressed: () async {
                  String dest =
                      await copyAssetToTempDir(asset: 'data/weather.csv');
                  ref.read(pathProvider.notifier).state = dest;

                  if (context.mounted) await rLoadDataset(context, ref);
                  setStatus(ref, statusChooseVariableRoles);

                  if (context.mounted) Navigator.pop(context, 'Demo');

                  datasetLoadedUpdate(ref);

                  // Access the PageController via Riverpod and move to the second page.

                  ref.read(pageControllerProvider).animateToPage(
                        // Index of the second page.

                        1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                },
                child: const Text('Demo'),
              ),
            ],
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
                child: const Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
