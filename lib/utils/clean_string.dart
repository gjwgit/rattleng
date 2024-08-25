/// General cleanup of strings from the R console.
//
// Time-stamp: <Tuesday 2024-08-20 13:47:14 +1000 Graham Williams>
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

// Group imports by dart, flutter, packages, local. Then alphabetically.


String removeAnsiControlSequences(String input) {
  // Regex to match ANSI escape codes.
  final ansiEscape = RegExp(r'\x1B\[[0-?]*[ -/]*[@-~]');
  return input.replaceAll(ansiEscape, '');
}

String cleanString(String txt) {
  // On moving to pty I was getting lots of escapes.
  
  txt = removeAnsiControlSequences(txt);
  return txt;
}
