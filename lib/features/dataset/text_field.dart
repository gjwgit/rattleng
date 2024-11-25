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
import 'package:markdown_tooltip/markdown_tooltip.dart';

import 'package:rattle/constants/keys.dart';
import 'package:rattle/constants/status.dart';
import 'package:rattle/features/dataset/popup.dart';
import 'package:rattle/providers/dataset_loaded.dart';
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/providers/path.dart';
import 'package:rattle/r/load_dataset.dart';
import 'package:rattle/utils/check_file_exists.dart';
import 'package:rattle/utils/set_status.dart';
import 'package:rattle/utils/show_error.dart';
import 'package:rattle/utils/show_dataset_alert_dialog.dart';

class DatasetTextField extends ConsumerStatefulWidget {
  @override
  _DatasetTextFieldState createState() => _DatasetTextFieldState();
}

class _DatasetTextFieldState extends ConsumerState<DatasetTextField> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    // Initialize the controller with the provider's initial value.

    final initialText = ref.read(pathProvider);
    _textController = TextEditingController(text: initialText);

    // Update the provider's value when the text changes.

    _textController.addListener(() {
      ref.read(pathProvider.notifier).state = _textController.text;
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final path = ref.watch(pathProvider);

    // Introduce a text controller that ensures the cursor remains where it is
    // when we have some text, rather than it being moved the left after a
    // rebuild.  The widget is rebuilt each time and so the cursor is set to the
    // left position and so the characters are effectively captured right to
    // left rather then left to right.  Update the controller's text only if it
    // differs from the provider's state.

    if (_textController.text != path) {
      _textController.text = path;
      _textController.selection = TextSelection.fromPosition(
        TextPosition(offset: _textController.text.length),
      );
    }

    return Expanded(
      // Use [Expanded] to fill the remainder of the row.

      child: MarkdownTooltip(
        message: '''

        **Filename:** You can paste or type the path to a file containing your
        dataset. It is expected to be a **csv** or **txt** file, or the name of
        a package dataset, like rattle::wattle.

        ''',
        child: TextField(
          // A [TextField] to contain the name of the selected dataset.

          key: datasetPathKey,

          // If the user updates the text then we need to send the new value
          // off to the DatabaseModel.

          //          onChanged: (newPath) {
          //            ref.watch(pathProvider.notifier).state = newPath;
          //          },

          // Waht to do when the user presses ENTER.

          onSubmitted: (newPath) async {
            // Simply ignore if the path is empty.

            if (newPath.isEmpty) return;

            if (!checkFileExists(context, newPath)) return;

            if (ref.read(datasetLoaded)) {
              showDatasetAlertDialog(context, ref, false);
            }

            ref.read(pathProvider.notifier).state = newPath;
            await rLoadDataset(context, ref);
            setStatus(ref, statusChooseVariableRoles);

            datasetLoadedUpdate(ref);

            // Access the PageController via Riverpod and move to the second page.

            ref.read(pageControllerProvider).animateToPage(
                  // Index of the second page.

                  1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
          },

          // For an empty value we show a helpful message.

          decoration: const InputDecoration(
            hintText: 'Path to dataset file or named dataset from a package.',
          ),

          // The controller displays the current path and accessing it from the
          // path provider ensures it is always the latest value displayed.

          controller: _textController,
        ),
      ),
    );
  }
}
