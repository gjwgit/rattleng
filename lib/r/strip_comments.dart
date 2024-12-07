/// Strip comments from an R console log string.
//
// Time-stamp: <Saturday 2024-11-30 10:37:04 +1100 Graham Williams>
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
/// Authors: Graham Williams

library;

String rStripComments(String txt) {
  List<String> lines = txt.split('\n');
  List<String> result = [];

  for (int i = 0; i < lines.length; i++) {
    // Keep only those lines that are not comments and not empty.

    if (!lines[i].startsWith('#') && lines[i].isNotEmpty) {
      // Strip comments at the end of the line.

      // Need to be clever to not strip # where # is embedded like in
      //
      // Ecdf(eds[eds$grp=="All",1], col="#E495A5", ...)
      //
      // Or like in
      //
      // title <- glue("Risk Chart &#8212; {mdesc}")
      //
      // Use a pattern with a negative lookbehind assertion (?<!\") which
      // ensures that the # is not preceded by a ".

      result.add(lines[i].replaceAll(RegExp(r' *(?<!\".*)#.*'), ''));
    }
  }

  // Remove empty lines on joining.

  String compressed = result.where((line) => line.trim().isNotEmpty).join('\n');

  // Add newlines at the beginning and the end to ensure the commands are on
  // lines of their own.

  return '\n$compressed\n';
}
