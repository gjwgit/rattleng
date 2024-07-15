/// A popup with choices for sourcing the dataset.
///
/// Time-stamp: <Monday 2024-07-15 11:19:56 +1000 Graham Williams>
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

import 'package:rattle/constants/status.dart';
import 'package:rattle/features/dataset/select_file.dart';
import 'package:rattle/providers/dataset_loaded.dart';
import 'package:rattle/providers/path.dart';
import 'package:rattle/r/load_dataset.dart';
import 'package:rattle/utils/set_status.dart';

const double heightSpace = 20;
const double widthSpace = 10;

void datasetLoadedUpdate(WidgetRef ref) {
  debugPrint('DATASET LOADED');
  ref.read(datasetLoaded.notifier).state = true;
}

class DatasetPopup extends ConsumerWidget {
  const DatasetPopup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    if (context.mounted) rLoadDataset(context, ref);
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

              // ElevatedButton(
              //   onPressed: () {
              //     // TODO 20231018 gjw datasetSelectPackage();
              //     Navigator.pop(context, 'Package');

              //     datasetLoadedUpdate(ref);
              //   },
              //   child: const Text('Package'),
              // ),

              // // SPACE

              // const SizedBox(width: widthSpace),

              // DEMO

              ElevatedButton(
                onPressed: () {
                  // TODO 20231101 gjw DEFINE setPath()

                  ref.read(pathProvider.notifier).state = 'rattle::weather';

                  // TODO 20240714 gjw HOW TO GET THE weather.csv FROM ASSETS
                  // ref.read(pathProvider.notifier).state =
                  //     'assets/data/weather.csv';
                  rLoadDataset(context, ref);
                  setStatus(ref, statusChooseVariableRoles);
                  Navigator.pop(context, 'Demo');

                  datasetLoadedUpdate(ref);
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
