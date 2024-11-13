/// An editable text field for the dataset name.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
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

library;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/keys.dart';
import 'package:rattle/constants/status.dart';
import 'package:rattle/features/dataset/popup.dart';
import 'package:rattle/providers/path.dart';
import 'package:rattle/r/load_dataset.dart';
import 'package:rattle/utils/check_file_exists.dart';
import 'package:rattle/utils/set_status.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';

class DatasetTextField extends ConsumerWidget {
  const DatasetTextField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final path = ref.watch(pathProvider);

    // Introduce a text controller that ensures the cursor is always on the
    // right after an update to the text field. Otherwise, because it is rebuilt
    // each time, the cursor is set to the left position and so the characters
    // are effectively captured right to left rather then left to right.

    final txtController = TextEditingController.fromValue(
      TextEditingValue(
        text: path,
        selection: TextSelection.collapsed(
          offset: path.length,
        ),
      ),
    );

    return Expanded(
      // Use [Expanded] to fill the remainder of the row.

      child: MarkdownTooltip(
        message: '''

        You can type the actual path to a file containing
        your dataset, perhaps as a CSV file, or the name of a
        package dataset, like rattle::wattle.

        ''',
        child: TextField(
          // A [TextField] to contain the name of the selected dataset.

          key: datasetPathKey,

          // If the user updates the text then we need to send the new value
          // off to the DatabaseModel.

          onChanged: (newPath) {
            ref.watch(pathProvider.notifier).state = newPath;
          },
          onSubmitted: (newPath) {
            if (checkFileExists(context, newPath)) {
              rLoadDataset(context, ref);
              setStatus(ref, statusChooseVariableRoles);

              datasetLoadedUpdate(ref);
            }
          },

          // For an empty value we show a helpful message.

          decoration: const InputDecoration(
            hintText: 'Path to dataset file or named dataset from a package.',
          ),

          // The controller displays the current path and accessing it from the
          // path provider ensures it is always the latest value displayed.

          controller: txtController,
        ),
      ),
    );
  }
}
