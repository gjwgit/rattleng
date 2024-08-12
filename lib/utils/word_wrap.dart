/// Word wrap a string.
//
// Time-stamp: <Sunday 2024-08-11 14:55:36 +1000 Graham Williams>
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

String wordWrap(
  String text, {
  int width = 60,
}) {
  // Split into lines.

  List<String> lines = text.split('\n');

  // Trim white space.

  lines = lines.map((str) => str.trim()).toList();

  // Split into paragraphs since each paragraph is going to be word wrapped.

  List<String> para = [];
  String currentPara = '';

  for (String line in lines) {
    if (line.isEmpty) {
      if (currentPara.isNotEmpty) {
        para.add(currentPara.trim());
        currentPara = '';
      }
    } else {
      if (currentPara.isNotEmpty) {
        currentPara += ' ';
      }
      currentPara += line.trim();
    }
  }

  // Add the last paragraph if there's any left after the loop

  if (currentPara.isNotEmpty) {
    para.add(currentPara.trim());
  }

  final RegExp pattern = RegExp('.{1,${width.toString()}}(\\s+|\$)');

  //  para = para.map((str) => actualWordWrap(str, width)).toList();

  para = para
      .map(
        (str) =>
            str.replaceAllMapped(pattern, (match) => '${match.group(0)!}\n'),
      )
      .toList();

  // Combine the paragraphs into one string with empty lines between
  // them. 20240811 gjw added trim() to remove any white space at the end of the
  // string. Will this affect anythig else?

  text = para.join('\n\n').trim();

  // text = result
  //     .replaceAllMapped(pattern, (match) => '${match.group(0)!}\n')
  //     .trim();

  // text = text.replaceAll(RegExp(r'^ +'), '');

  return text;
}
