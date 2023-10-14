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
/// Authors: Graham Williams, Yiming Lu

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:rattle/constants/status.dart';
import 'package:rattle/dataset/select_file.dart';
import 'package:rattle/r/load_dataset.dart';
import 'package:rattle/models/rattle_model.dart';

const double heightSpace = 20;
const double widthSpace = 10;

class DatasetPopup extends StatelessWidget {
  const DatasetPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RattleModel rattle = Provider.of<RattleModel>(context, listen: false);
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
                  fontSize: 25,
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
              // Choose a FILENAME to load and load it.
              ElevatedButton(
                onPressed: () {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();

                  if (datasetSelectFile(rattle)) {
                    rattle.setStatus(statusChooseVariableRoles);
                  } else {
                    // If the file selection was canceled, show a snackbar message.

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('File selection was canceled.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: const Text('Filename'),
              ),
              // Space between buttons.
              const SizedBox(width: widthSpace),
              ElevatedButton(
                onPressed: () {
                  null;
                },
                child: const Text('Package'),
              ),
              // Space between buttons.
              const SizedBox(width: widthSpace),
              ElevatedButton(
                onPressed: () {
                  String selectedFileName = "rattle::weather";
                  rattle.setPath(selectedFileName);
                  rLoadDataset(rattle);
                  rattle.setStatus(statusChooseVariableRoles);
                  Navigator.pop(context, "Demo");
                },
                child: const Text('Demo'),
              ),
            ],
          ),
          // Space between rows.
          const SizedBox(height: heightSpace),
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
