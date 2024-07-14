/// Strip comments from an R console log string.
//
// Time-stamp: <Sunday 2024-07-14 08:21:00 +1000 Graham Williams>
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
/// Authors: <AUTHORS>

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
      // Uase a pattern with a negative lookbehind assertion (?<!\") which
      // ensures that the # is not preceded by a ".

      result.add(lines[i].replaceAll(RegExp(r' *(?<!\")#.*'), ''));
    }
  }

  // Add newlines at the beginning and the end to ensure the commands are on
  // lines of their own.

  return "\n${result.join('\n')}\n";
}
