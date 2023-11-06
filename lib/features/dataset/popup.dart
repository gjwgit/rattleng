/// A popup with choices for sourcing the dataset.
///
/// Time-stamp: <Sunday 2023-11-05 20:52:34 +1100 Graham Williams>
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

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/status.dart';
import 'package:rattle/features/dataset/select_file.dart';
import 'package:rattle/provider/path.dart';
import 'package:rattle/r/load_dataset.dart';
import 'package:rattle/utils/set_status.dart';

const double heightSpace = 20;
const double widthSpace = 10;

class DatasetPopup extends ConsumerWidget {
  const DatasetPopup({Key? key}) : super(key: key);

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
                    rLoadDataset(ref);
                    setStatus(ref, statusChooseVariableRoles);
                  }

                  // Avoid the "Do not use BuildContexts across async gaps."
                  // warning.

                  if (!context.mounted) return;
                  Navigator.pop(context, "Filename");
                },
                child: const Text('Filename'),
              ),

              // SPACE

              const SizedBox(width: widthSpace),

              // PACKAGE

              ElevatedButton(
                onPressed: () {
                  // TODO 20231018 gjw datasetSelectPackage();
                  Navigator.pop(context, "Package");
                },
                child: const Text('Package'),
              ),

              // SPACE

              const SizedBox(width: widthSpace),

              // DEMO

              ElevatedButton(
                onPressed: () {
                  // TODO 20231101 gjw DEFINE setPath()
                  ref.read(pathProvider.notifier).state = "rattle::weather";
                  rLoadDataset(ref);
                  setStatus(ref, statusChooseVariableRoles);
                  Navigator.pop(context, "Demo");
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
                  Navigator.pop(context, "Cancel");
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
