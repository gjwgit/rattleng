/// Choose and load a file as the source dataset.
///
/// Time-stamp: <Monday 2024-06-03 07:36:51 +1000 Graham Williams>
///
/// Copyright (C) 2023, Togaware Pty Ltd.
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
/// Authors: Yiming Lu, Graham Williams

import 'package:file_picker/file_picker.dart';
import 'package:gtk/gtk.dart';
import 'package:rattle/gtk_recent_files.dart';

Future<String> datasetSelectFile() async {
  // Use the [FilePicker] to select a file asynchronously so as not to block the
  // main UI thread.

  FilePickerResult? result = await FilePicker.platform.pickFiles(
    dialogTitle: "Choose a csv/txt file to load as your dataset.",
    type: FileType.custom,
    allowedExtensions: ['csv', 'txt'],
  );

  String path = "";

  if (result != null) {
    // If a file was selected then extract the path from the selected file.

    path = result.files.single.path!;

    // TODO 20240603 gjw Try to save the file to recent files as store in
    // `.local/share/recently-used.xbel`

    print(path);
    // GtkRecentInfo info = GtkRecentInfo();
    // info.set_uri(path);
    // info.set_application_name('RattleNG');
    // info.set_mimetype('text/plain');
    // GtkRecentManager.add_item(info);
    addRecentFile(path);
  }

  return path;
}
