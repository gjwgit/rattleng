/// Utility to extract the latest glimpse output from R.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Sunday 2024-09-01 09:37:58 +1000 Graham Williams>
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

String rExtractGlimpse(String txt) {
  // If it appears that R has not yet finished loading the dataset then return
  // an appropriate message.

  // if (txt.contains("Error: object 'ds' not found")) {
  //   return ('The dataset appears to still be loading. Please wait.');
  // }

  // Split the string into lines.

  List<String> lines = txt.split('\n');

  List<String> result = [];

  // Initialize with a value that indicates no start index found.

  int startIndex = -1;

  // If the dataset is loaded from a CSV file or the demo dataset it will be
  // summarised by R's `glimpse(ds)` command. For a TXT file we use `cat(ds,
  // sep = "\n")`. In either case we find the latest instance and return the
  // output for display in RattleNG.

  for (int i = lines.length - 1; i >= 0; i--) {
    if (lines[i].contains('> glimpse(ds') || lines[i].contains('> cat(ds,')) {
      startIndex = i;
      break;
    }
  }

  if (startIndex != -1) {
    for (int i = startIndex + 1; i < lines.length; i++) {
      if (lines[i].startsWith('>')) {
        // Found the next line starting with '>'. Stop adding lines to the
        // result.

        break;
      }

      // Remove '$ ' at the start.

      String strippedLine = lines[i].replaceAll(RegExp(r'^\$ '), '');

      result.add(strippedLine);
    }
  }

  // Add a blank line after the first two lines.

  if (result.length >= 2) {
    // Insert an empty string at index 2.

    result.insert(2, '');
  }

  // Join the lines.

  return result.join('\n');
}
