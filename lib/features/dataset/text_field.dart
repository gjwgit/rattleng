/// An editable text field for the dataset name.
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

import 'package:rattle/constants/keys.dart';
//import 'package:rattle/models/rattle_model.dart';
import 'package:rattle/widgets/delayed_tooltip.dart';

class DatasetTextField extends StatelessWidget {
  const DatasetTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
//    return Consumer<RattleModel>(
    // Build a [Consumer] of the [RattleModel] so we can access updated
    // values of the path variable.

//      builder: (context, rattle, child) {
    // The builder takes a context, a RattleMode, and the child. It is the
    // `rattle` that contains the state that we can access here.

    return Expanded(
      // Expand to fill the remainder of the row.

      child: DelayedTooltip(
        message: "You can type the actual path to a file containing\n"
            "your dataset, perhaps as a CSV file, or the name of a\n"
            "package dataset, like rattle::wattle.",
        child: TextField(
          // A text field to contain the name of the selected dataset.

          key: datasetPathKey,

          // If the user updates the text then we need to send the new value
          // off to the DatabaseModel.

          onChanged: (newPath) {
            //              rattle.setPath(newPath);
          },

          // For an empty value we show a helpful message.

          decoration: const InputDecoration(
            hintText: 'Path to dataset file or named dataset from a package.',
            border: OutlineInputBorder(),
          ),

          // The controller displays the current path and accessing it from
          // the DatabaseModel ensures it is always the lates value displayed.

          controller: TextEditingController(text: "rattle.path"),
        ),
      ),
    );
//      },
//    );
  }
}
