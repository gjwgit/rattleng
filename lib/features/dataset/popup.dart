/// A popup with choices for sourcing the dataset.
///
/// Time-stamp: <Friday 2024-09-06 19:23:54 +1000 Graham Williams>
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

import 'package:rattle/constants/app.dart';
import 'package:rattle/constants/status.dart';
import 'package:rattle/features/dataset/select_file.dart';
import 'package:rattle/providers/dataset_loaded.dart';
import 'package:rattle/providers/page_index.dart';
import 'package:rattle/providers/path.dart';
import 'package:rattle/r/load_dataset.dart';
import 'package:rattle/utils/set_status.dart';
import 'package:rattle/widgets/pages.dart';

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

          const SizedBox(height: heightSpace),

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

                  datasetLoadedUpdate(ref);
                },
                child: const Text('Package'),
              ),

              // SPACE

              const SizedBox(width: widthSpace),

              // DEMO

              ElevatedButton(
                onPressed: () async {
                  // Load the dataset as before
                  ref.read(pathProvider.notifier).state = weatherDemoFile;
                  await rLoadDataset(context, ref);
                  setStatus(ref, statusChooseVariableRoles);

                  if (context.mounted) Navigator.pop(context, 'Demo');

                  datasetLoadedUpdate(ref);

                  await Future.delayed(const Duration(seconds: 6));

                  print("test 1");

                  // Check if the widget is still mounted before updating the provider's state
                  if (context.mounted) {
                    ref.read(pageIndexProvider.notifier).state = 1;
                  }

                  // to navigate to the second page
                },
                child: const Text('Demo'),
              ),
            ],
          ),

          // SPACE between row of options and the cancel button.

          const SizedBox(height: heightSpace),

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
