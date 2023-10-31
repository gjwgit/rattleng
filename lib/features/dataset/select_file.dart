/// Choose and load a file as the source dataset.
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
/// Authors: Yiming Lu, Graham Williams

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';

Future<String> datasetSelectFile() async {
  // Use the FilePicker to select a file asynchronously so as not to block the
  // main UI thread.

  FilePickerResult? result = await FilePicker.platform.pickFiles(
    dialogTitle: "Choose a csv file to load as your dataset.",
    type: FileType.custom,
    allowedExtensions: ['csv'],
  );

  // Check if a file was selected.

  String path = "";

  if (result != null) {
    // Extract the path from the selected file.

    path = result.files.single.path!;
  }

  return path;
}
