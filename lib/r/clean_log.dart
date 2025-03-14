/// Utility to strip lines from an R script file t to ignore for extract.
///
/// Time-stamp: <Friday 2025-03-14 16:03:04 +1100 Graham Williams>
///
/// Copyright (C) 2025, Togaware Pty Ltd.
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
/// Authors: Graham Williams

library;

/// From the supplied [log] (an R script file contents) strip any line that
/// begins with `patterns that we should be ignoring for extracting actual
/// output.

String rCleanLog(String log) {
  // Split the string into lines.

  List<String> lines = log.split('\n');

  List<String> filteredLines = lines
      // Filter out lines that start with '> em_prop'. This is the particular
      // example that motivated this function. On Windows the `> em_prop` was
      // being printed at the beginning of the line, wheres on Linux it is at
      // the end of the previous line. Hence whenscraping the ERROR MATRIX on
      // Windows no ERROR MATRIX was found since the next line after our tag
      // line started with '>'. So let's strip it before extracting the output
      // ERROR MATRIX (gjw 20250314).
      // .map((line) => line.replaceAll(RegExp('> em_prop(?!\s)', ''))
      // .map((line) => line.replaceAll('> em_count', ''))
      // .map((line) => line.replaceAll('> cat(error_summary)', ''))
      .where((line) => !RegExp(r'^> em_prop$').hasMatch(line))
      .where((line) => !RegExp(r'^> em_count$').hasMatch(line))
      .where((line) => !RegExp(r'^> cat(error_summary)$').hasMatch(line))
      .toList();

  // Join the filtered lines back into a single string.

  String result = filteredLines.join('\n');

  return result;
}
