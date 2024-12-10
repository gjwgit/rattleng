/// Utility to strip TODO lines from an R script file.
///
/// Time-stamp: <Tuesday 2024-12-10 17:03:56 +1100 Graham Williams>
///
/// Copyright (C) 2024, Togaware Pty Ltd.
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

/// From the supplied [code] (an R script file contents) strip any line that
/// begins with `# TODO` so as not to expose such lines to the final script
/// file.

String rStripTodo(String code) {
  // Split the string into lines.

  List<String> lines = code.split('\n');

  List<String> filteredLines = lines
      // Filter out lines that start with optional whitespace followed by '#
      // TODO'.
      .where((line) => !RegExp(r'^\s*# TODO').hasMatch(line))
      // Filter out lines that start with optional whitespace followed by '##'
      // as markerts of things to be done and not included in the user scripts.
      .where((line) => !RegExp(r'^\s*##[^#]').hasMatch(line))
      .where((line) => !RegExp(r'^\s*##$').hasMatch(line))
      .toList();

  // Join the filtered lines back into a single string.

  String result = filteredLines.join('\n');

  return result;
}
