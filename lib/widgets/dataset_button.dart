/// A button to choose a dataset (from file or a package).
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

import 'package:rattle/helpers/load_dataset.dart' show loadDataset;
import 'package:rattle/models/dataset_model.dart';

class DatasetButton extends StatelessWidget {
  const DatasetButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // Obtain the current path.

        String currentPath =
            Provider.of<DatasetModel>(context, listen: false).path;

        if (currentPath == "") {
          debugPrint("NO PATH SO POPUP A CHOICE OF FILE or PACKAGE or DEMO.");
          // Obtain the dataset name
          debugPrint("FOR NOW SET THE DATASET AS rattle::weather.");
          String selectedFileName = "rattle::weather";
          // Update the selected filename using the Provider.

          Provider.of<DatasetModel>(context, listen: false)
              .setPath(selectedFileName);
        } else {
          debugPrint("PATH : ${currentPath}");
        }

        debugPrint("NOW LOAD THE DATASET THEN REPLACE THE WELCOME MESSAGE");

        loadDataset(currentPath);
      },
      child: const Text("Dataset"),
    );
  }
}
