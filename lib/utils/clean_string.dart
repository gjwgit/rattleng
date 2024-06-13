/// General cleanup of strings from the R console.
//
// Time-stamp: <Thursday 2024-06-13 11:26:32 +1000 Graham Williams>
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

String cleanString(String txt) {
  // On moving to pty I was getting lots of escapes.

  txt = txt.replaceAll('', '');
  txt = txt.replaceAll('\r', '');
  txt = txt.replaceAll('[3m[38;5;246m', '');
  txt = txt.replaceAll('[?2004l', '');
  txt = txt.replaceAll('[39m[23m', '');
  txt = txt.replaceAll('[?2004h', '');
  txt = txt.replaceAll('[A', '');
  txt = txt.replaceAll('[C', '');
  txt = txt.replaceAll('[?25h', '');
  txt = txt.replaceAll('[K', '');
  txt = txt.replaceAll(RegExp(r'\[3.m'), '');

  // 20240602 gjw Remove the `[3m[90m` that appears in the output now. Not
  // sure where that has come from or when it sneaked in.

  txt = txt.replaceAll('[3m[90m', '');

  return txt;
}
