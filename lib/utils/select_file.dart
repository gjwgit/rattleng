/// Promt the user to select a name and location to save a file.
//
// Time-stamp: <Friday 2024-11-01 09:51:36 +1100 Graham Williams>
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
/// Authors: Yixiang Yin, Graham Williams, Lutra

library;

import 'package:file_picker/file_picker.dart';

Future<String?> selectFile({
  String defaultFileName = 'image.svg',
  List<String> allowedExtensions = const ['svg'],
}) async {
  // Use a [FilePicker] to select a file. This is performed asynchronously so as
  // not to block the main UI thread.

  String? result = await FilePicker.platform.saveFile(
    dialogTitle: 'Provide a filename to save the file to',
    fileName: defaultFileName,
    type: FileType.custom,
    allowedExtensions: allowedExtensions,
  );

  return result;
}
