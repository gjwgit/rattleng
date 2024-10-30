/// Promote the user to pick a location to save the file
//
// Time-stamp: <Sunday 2024-09-08 13:47:39 +1000 Graham Williams>
//
/// Copyright (C) 2024, Togaware Pty Ltd
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
/// Authors: Yixiang Yin, Graham Williams

library;

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'package:file_picker/file_picker.dart';

Future<String?> selectFile({
  String defaultFileName = 'image.svg',
  List<String> allowedExtensions = const ['svg'],
}) async {
  // Use the [FilePicker] to select a file asynchronously so as not to block the
  // main UI thread.

  String? result = await FilePicker.platform.saveFile(
    dialogTitle: 'Provide a filename to save the file to',

    // NOTE 20240604 gjw DEFAULT FILE NAME, TILE, ETC DOES NOT APPEAR IN DIALOG.
    //
    // Seems to be a Linux or even Ubuntu/Gnome issue. However it works okay for
    // saving in the SCRIPT tab? Works for Lutra-Fs on Windows and Linux
    // (zenity). 20240908 gjw

    fileName: defaultFileName,
    type: FileType.custom,
    allowedExtensions: allowedExtensions,
  );

  return result;
}
