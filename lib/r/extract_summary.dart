/// Utility to extract the latest summary(ds) output from R.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Saturday 2024-08-10 14:39:53 +1000 Graham Williams>
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
/// Authors: Graham Williams

library;

import 'package:rattle/r/extract.dart';

import 'remove_windows_chars.dart';

String rExtractSummary(String txt) {
  String content = rExtract(txt, 'summary(ds)');

  // Add a blank line between each sub-table.

  List<String> lines = content.split('\n');

  for (int i = 0; i < lines.length; i++) {
    if (lines[i].startsWith('  ') && !lines[i].trimLeft().startsWith('NA')) {
      lines[i] = '\n${lines[i]}';
    }
  }

  content = lines.join('\n');

  // Replace multiple empty lines with a single empty line.

  content = content.replaceAll(RegExp(r'\n\s*\n\s*\n+'), '\n\n');

  // Clean the result.

  content = removeWindowsChars(content);

  return content;
}
