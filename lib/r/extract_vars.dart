/// Utility to extract the latest names(ds) output from R.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Wednesday 2023-10-18 17:27:44 +1100 Graham Williams>
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

List<String> rExtractVars(String txt) {
  // Split the string based on lines.

  List<String> lines = txt.split('\n');

  // The result is a list of variable names (Strings).

  List<String> result = [];

  // Find the start of the latest string of interest. Begin by initializing a
  // value that indicates no start index found.

  int startIndex = -1;

  for (int i = lines.length - 1; i >= 0; i--) {
    if (lines[i].contains("> names(ds)")) {
      startIndex = i;
      break;
    }
  }

  // If the pattern of interest was found then begin collecting lines of output
  // from the R Console.

  if (startIndex != -1) {
    for (int i = startIndex + 1; i < lines.length; i++) {
      if (lines[i].startsWith(">")) {
        // Found the next line starting with the R prompt '>'. Stop adding lines
        // to the result. Assumes no lines, after the pattern of interest, that
        // contain the output we want to capture start with the R prompt '>'.

        break;
      }

      result.add(lines[i]);
    }
  }

  // Join all lines into one string to work on it now to extract the variable
  // names.

  String vars = result.join(" ");

  // Remove the [1] line numbering in the output.

  vars = vars.replaceAll(RegExp(r' *\[\d+\] *'), ' ');

  // Remove extra spaces.

  vars = vars.replaceAll(RegExp(r' +'), ' ');
  vars = vars.replaceAll(RegExp(r'^ +'), '');
  vars = vars.replaceAll(RegExp(r' +$'), '');

  // Split into the list of variable names.

  result = vars.split(' ');

  // Return the list of variable names.

  return result;
}
