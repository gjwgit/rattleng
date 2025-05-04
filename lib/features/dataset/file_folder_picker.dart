/// Choose and load a file or folder as the dataset source.
///
/// Time-stamp: <Monday 2025-03-10 05:33:13 +1100 Graham Williams>
///
/// Copyright (C) 2025, Togaware Pty Ltd.
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
/// Authors: Yiming Lu, Graham Williams, Zheyuan Xu
library;

import 'package:flutter/foundation.dart';

import 'package:file_picker/file_picker.dart';

/// Select a file for dataset loading using a file picker dialog.
Future<String> datasetSelectFile() async {
  // Use the [FilePicker] to select a file asynchronously so as not to block the
  // main UI thread.

  FilePickerResult? result = await FilePicker.platform.pickFiles(
    dialogTitle: 'Choose a file to load as your dataset.',
    type: FileType.custom,
    allowedExtensions: ['csv', 'xlsx', 'txt'],
  );

  String path = '';

  if (result != null) {
    // If a file was selected then extract the path from the selected file.

    path = result.files.single.path!;
  }

  return path;
}

/// Select a folder for dataset loading using a directory picker dialog.
Future<String?> datasetSelectFolder() async {
  try {
    // Use file_picker package to select folder.

    String? selectedDirectory = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Choose a folder to load as your dataset source.',
    );
    
    if (selectedDirectory == null) {
      // User canceled the picker.

      return null;
    }
    
    return selectedDirectory;
  } catch (e) {
    debugPrint('Error selecting folder: $e');
    return null;
  }
} 