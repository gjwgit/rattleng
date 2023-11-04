/// Utility to extract the latest glimpse output from R.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Saturday 2023-11-04 21:32:33 +1100 Graham Williams>
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

String rExtractGlimpse(String txt) {
  // Split the string into lines.

  List<String> lines = txt.split('\n');

  List<String> result = [];

  // Initialize with a value that indicates no start index found.

  int startIndex = -1;

  for (int i = lines.length - 1; i >= 0; i--) {
    if (lines[i].contains("> glimpse(ds)")) {
      startIndex = i;
      break;
    }
  }

  if (startIndex != -1) {
    for (int i = startIndex + 1; i < lines.length; i++) {
      if (lines[i].startsWith(">")) {
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
