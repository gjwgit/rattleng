/// Word wrap a string.
//
// Time-stamp: <Tuesday 2024-07-23 14:43:48 +1000 Graham Williams>
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

String wordWrap(String text, [int width = 60]) {
  // Remove newlines and repeated spaces.

  text = text.replaceAll(RegExp(r'\n'), ' ').replaceAll(RegExp(r' +'), ' ');

  final RegExp pattern = RegExp('.{1,${width.toString()}}(\\s+|\$)');

  text =
      text.replaceAllMapped(pattern, (match) => '${match.group(0)!}\n').trim();

  text = text.replaceAll(RegExp(r'^ +'), '');

  return text;
}
