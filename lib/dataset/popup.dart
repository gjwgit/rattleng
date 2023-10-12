/// A popup with choices for sourcing the dataset.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
// Licensed under the GNU General Public License, Version 3 (the "License");
///
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

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:rattle/r/load_dataset.dart';
import 'package:rattle/models/rattle_model.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class DatasetPopup extends StatelessWidget {
  const DatasetPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              SizedBox(width: 8), // Space between icon and title.
              Text(
                'Choose the Dataset Source:',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20), // Space between title and buttons.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  _selectFile(context);
                },
                child: const Text('Filename'),
              ),
              const SizedBox(width: 10), // Space between buttons.
              ElevatedButton(
                onPressed: () {
                  null;
                },
                child: const Text('Package'),
              ),
              const SizedBox(width: 10), // Space between buttons.
              ElevatedButton(
                onPressed: () {
                  RattleModel rattle =
                      Provider.of<RattleModel>(context, listen: false);
                  String selectedFileName = "rattle::weather";
                  rattle.setPath(selectedFileName);
                  rLoadDataset(rattle);
                  rattle.setStatus(
                    "Choose **variable roles** and then proceed to "
                    "analyze and model your data via the other tabs.",
                  );
                  Navigator.pop(context, "Demo");
                },
                child: const Text('Demo'),
              ),
            ],
          ),
          const SizedBox(height: 20), // Space between rows.
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

void _selectFile(BuildContext context) async {
  // Use the FilePicker to select a file asynchronously.
  FilePickerResult? result = await FilePicker.platform.pickFiles();

  // Check if a file was selected.
  if (result != null) {
    // Convert the selected file into a File object.
    File file = File(result.files.single.path!);

    // Fetch the RattleModel from the Provider.
    RattleModel rattle = Provider.of<RattleModel>(context, listen: false);

    // Set the path of the selected file in the RattleModel.
    rattle.setPath(file.path);

    // Load the dataset using the selected file's path.
    rLoadDataset(rattle);

    // Update the status message in the RattleModel.
    rattle.setStatus(
      "Choose **variable roles** and then proceed to "
      "analyze and model your data via the other tabs.",
    );

    // Close the file picker dialog.
    Navigator.pop(context, "Filename");
  } else {
    // If the file selection was canceled, show a snackbar message.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('File selection was canceled.'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

// // Obtain the current path.

// RattleModel rattle = Provider.of<RattleModel>(context, listen: false);
// String currentPath = rattle.path;

// if (currentPath == "") {
//   debugPrint("NO PATH SO POPUP A CHOICE OF FILE or PACKAGE or DEMO.");
//   // Obtain the dataset name
//   debugPrint("FOR NOW SET THE DATASET AS rattle::weather.");
//   String selectedFileName = "rattle::weather";
//   // Update the selected filename using the Provider.

//   Provider.of<RattleModel>(context, listen: false)
//       .setPath(selectedFileName);
// } else {
//   debugPrint("PATH : $currentPath");
// }

// // Request the dataset to be loaded, and pass the rattle model across so
// // that the script can be added to it.

// rLoadDataset(currentPath, rattle);

// rattle.setStatus("Choose **variable roles** and then proceed to "
//     "analyze and model your data via the other tabs.");
