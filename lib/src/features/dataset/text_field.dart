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

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/src/provider/path.dart';

import 'package:rattle/src/constants/keys.dart';
import 'package:rattle/src/widgets/delayed_tooltip.dart';

class DatasetTextField extends ConsumerWidget {
  const DatasetTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final path = ref.watch(pathProvider);

    // Introduce a text controller that ensures the cursor is always on the
    // right after an update to the text feild, otherwise because it is rebuilt
    // each time, the cursor is set to the left position.

    final txtController = TextEditingController.fromValue(TextEditingValue(
        text: path,
        selection: new TextSelection.collapsed(offset: path.length)));

    return Expanded(
      // Use [Expanded] to fill the remainder of the row.

      child: DelayedTooltip(
        message: "You can type the actual path to a file containing\n"
            "your dataset, perhaps as a CSV file, or the name of a\n"
            "package dataset, like rattle::wattle.",
        child: TextField(
          // A [TextField] to contain the name of the selected dataset.

          key: datasetPathKey,

          // If the user updates the text then we need to send the new value
          // off to the DatabaseModel.

          onChanged: (newPath) {
            ref.watch(pathProvider.notifier).state = newPath;
          },

          // For an empty value we show a helpful message.

          decoration: const InputDecoration(
            hintText: 'Path to dataset file or named dataset from a package.',
            border: OutlineInputBorder(),
          ),

          // The controller displays the current path and accessing it from the
          // DatabaseModel ensures it is always the lates value displayed.

          // TODO 20231031 gjw UNFORTUNATELY ADDING THIS CONTROLLER MAKES THE
          // TEXT IN THE TEXT FIELD GO BACKWAREDS!

          controller: txtController,
        ),
      ),
    );
  }
}
