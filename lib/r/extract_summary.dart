/// Utility to extract the latest summary(ds) output from R.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Saturday 2024-08-10 17:51:29 +1000 Graham Williams>
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
import 'package:rattle/utils/clean_string.dart';

String rExtractSummary(String txt) {
  String content = rExtract(txt, '> summary(ds)');

  // Add a blank line between each sub-table.

  List<String> lines = content.split('\n');

  // Process each line to add spacing between variable summaries.

  for (int i = 0; i < lines.length; i++) {
    // Check if the line is a new variable by looking for:
    // 1. Lines that start with 2-6 spaces (indented but not too far).
    // 2. Lines that have content after the spaces.
    // 3. Lines that don't start with 'NA' or '(Other)' (which are continuation lines)

    if (lines[i].startsWith('  ') &&
        lines[i].trimLeft().length > 0 &&
        lines[i].length - lines[i].trimLeft().length < 7 &&
        !lines[i].trimLeft().startsWith('NA') &&
        !lines[i].trimLeft().startsWith('(Other)')) {
      // Add a blank line before this line to separate variable summaries.

      lines[i] = '\n${lines[i]}';
    }
  }

  content = lines.join('\n');

  // Replace multiple empty lines with a single empty line.

  content = content.replaceAll(RegExp(r'\n\s*\n\s*\n+'), '\n\n');

  // Clean the result.

  content = cleanString(content);

  return content;
}
