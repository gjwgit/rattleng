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

import 'package:file_picker/file_picker.dart';

import 'package:rattle/constants/status.dart';
import 'package:rattle/models/rattle_model.dart';
import 'package:rattle/r/load_dataset.dart';

//void datasetSelectFile(RattleModel rattle) async {
void datasetSelectFile() async {
  // Use the FilePicker to select a file asynchronously so as no to block the
  // main UI thread.

  FilePickerResult? result = await FilePicker.platform.pickFiles(
    dialogTitle: "Choose a csv file to load as your dataset.",
    type: FileType.custom,
    allowedExtensions: ['csv'],
  );

  // Check if a file was selected.

  if (result != null) {
    // Convert the selected file into a File object.

    File file = File(result.files.single.path!);

    // Set the path of the selected file in the [RattleModel] so that it is
    // generally available across the app.

//    rattle.setPath(file.path);

    // Load the dataset using the selected file's path obtained from the
    // [rattle] object.

//    rLoadDataset(rattle);

    // Set the status bar. Do so within the call here as otherwise if it is
    // outside of this async function, it gets done asynchronously, and so while
    // we are selecting the file rather than after the file is selected.

//    rattle.setStatus(statusChooseVariableRoles);
  }
}
