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

import 'package:rattle/helpers/r_load_dataset.dart';
import 'package:rattle/models/rattle_model.dart';

class DatasetButton extends StatelessWidget {
  const DatasetButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // Obtain the current path.

        RattleModel rattle = Provider.of<RattleModel>(context, listen: false);
        String currentPath = rattle.path;

        if (currentPath == "") {
          debugPrint("NO PATH SO POPUP A CHOICE OF FILE or PACKAGE or DEMO.");
          // Obtain the dataset name
          debugPrint("FOR NOW SET THE DATASET AS rattle::weather.");
          String selectedFileName = "rattle::weather";
          // Update the selected filename using the Provider.

          Provider.of<RattleModel>(context, listen: false)
              .setPath(selectedFileName);
        } else {
          debugPrint("PATH : $currentPath");
        }

        debugPrint("NOW LOAD THE DATASET THEN REPLACE THE WELCOME MESSAGE");

        // TODO 20230913 gjw PERHAPS REDESIGN FOR LOADDATASET TO RETURN THE
        // SCRIPT AS A STRING. THEN PASS THE STRING TO THE r PROCESS TO RUN AND
        // THE PASS THE STRING TO THE RATTLE MODEL TO PUBLISH IN THE SCRIPT.

        rLoadDataset(currentPath, rattle);

        // code = rLoadDataset(currentPath);
        // process.stdin.writeln(code);
        // rattle.appendScript(code);

        rattle.setStatus("Choose **variable roles** and then proceed to "
            "analyze and model your data via the other tabs.");
      },
      child: const Tooltip(
        message: "Click here to have the option to load the data from a file,\n"
            "including CSV files, or from an R pacakge, or to load \n"
            "the demo dataset, rattle::weather.",
        child: Text("Dataset"),
      ),
    );
  }
}
