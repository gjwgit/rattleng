/// CSV Save button.
//
// Time-stamp: <Monday 2025-03-10 09:34:16 +1100 Graham Williams>
//
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
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
/// Authors: Zheyuan Xu

library;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_selector/file_selector.dart' as fs;

import 'package:rattle/r/execute.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';

/// A CSV Save Button widget. When tapped, it opens a file-save dialog 
/// for the user to choose a CSV location, then executes an R command 
/// to save the current dataset 'ds' to that file.

class SaveDatasetButton extends ConsumerWidget {
  const SaveDatasetButton({super.key});

  Future<void> _saveDataset(WidgetRef ref, BuildContext context) async {

    final String? path = await fs.getDirectoryPath();

    // If the user cancels or no path is chosen, do nothing.

    if (path == null || path.isEmpty) {
      return;
    }

    // Escape backslashes if needed (e.g., on Windows).

    final escapedPath = path.replaceAll('\\', '\\\\');

    // Build the R command to save the dataset ds to CSV without row names.

    final rCommand = 'write.csv(ds, file="$escapedPath", row.names=FALSE)\n';

    // Execute the R command.
    
    rExecute(ref, rCommand);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MarkdownTooltip(
      message: '''
      
      **Save.** Tap here to save the current ds to a CSV file.
      
      ''',
      child: IconButton(
        icon: const Icon(Icons.save_alt, color: Colors.blue),
        tooltip: 'Save current ds to CSV file',
        onPressed: () {
          _saveDataset(ref, context);
        },
      ),
    );
  }
}
