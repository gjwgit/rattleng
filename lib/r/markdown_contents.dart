/// Utility to convert outout of contents(ds) into markdown
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Thursday 2024-06-13 16:19:04 +1000 Graham Williams>
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

/// EXPERIMENTAL AND NOT CURRENTLY USED - KEEP FOR NOW

library;

// import 'package:flutter/material.dart';

// String rMarkdownContents(String data) {
//   /// Convert the raw text into a markdown rendering.

//   // Handy constants for debugPrint.

//   const fn = 'rMarkdownContents';
//   const fne = '$fn: Error:';
//   const fni = '$fn: Info:';

//   // Add a heading.

//   data = '**Summary of the Dataset**\n$data';

//   List<String> lines = data.split('\n');

//   // Find the line with `Levels`, insert begin code block.

//   RegExp regExp = RegExp(r'^ {16}Levels');

//   int start = lines.indexWhere((line) => regExp.hasMatch(line));

//   if (start == -1) {
//     debugPrint('$fne Beginning of variables table not found.');

//     return data;
//   }

//   int end = lines.indexWhere((line) => line.isEmpty, start);

//   if (end == -1) {
//     debugPrint('$fne End of variables table not found.');

//     return data;
//   }

//   debugPrint('$fni Variables table begins $start and ends $end');

//   lines.insert(start - 1, '**Variables**');
//   start += 1;

//   // Build the heading for the variables table.

//   lines[start] = lines[start].replaceAll(RegExp(r'\s+'), ' ');
//   lines[start] = lines[start].trimLeft();

//   List<String> words = lines[start].split(' ');

//   if (words.length != 4) {
//     debugPrint('$fne Expected 4 words for heading but found ${words.length}');

//     return data;
//   }

//   lines[start] = '|Variable|${words.join("|")}|';
//   lines.insert(start + 1, '|:--|:--|:--|:--|:--|');
//   start += 2;

//   // Format each row as required. Assuming the variable name does not have
//   // spaces in it. If there are 5 words in a line the it is a factor, if 4
//   // variable is a factor then there will be 5 words, otherwise

//   // for (int i = start; i < end; i++) {
//   //   // Remove multiple spaces.

//   //   lines[i] = lines[i].replaceAll(RegExp(r'\s+'), ' ');

//   //   // Extract the words.

//   //   words = lines[i].split(' ');

//   //   // If the second word is numeric then it is the levels.

//   //   RegExp intRegExp = RegExp(r'^[+-]?\d+$');

//   //   if (intRegExp.hasMatch(words[1]) {
//   //     if (words.length == 4) {
//   //       lines[i] = '|${words[0]}|${words[1]}||${words[2]}|${words[3]}|';
//   //     } else {
//   //       lines[i] = '|${words[0]}|${words[1]}||${words[2]}|${words[3]}|';
//   //     }
//   //   }
//   // }

//   // Replace multiple spaces with a single space in every line between start
//   // and end.

//   for (int i = start; i < end; i++) {
//     lines[i] = lines[i].replaceAll(RegExp(r'\s+'), ' ');
//   }

//   // Insert '|' in the appropraite place for the rest of the table.

//   // for (int i = start + 2; i < end + 1; i++) {
//   //   // Split the line into words

//   //   List<String> words = lines[i].split(' ');

//   //   // Join the last 4 last words with spaces

//   //   String lastFourWords =
//   //       words.length > 4 ? words.sublist(words.length - 4).join(' ') : lines[i];

//   //   // Replace spaces between the last 4 words with '|'
//   //   lines[i] =
//   //       "|${lines[i].replaceRange(lines[i].lastIndexOf(lastFourWords), lines[i].length, lastFourWords.replaceAll(' ', '|'))}|";
//   // }

//   // for (int i = start + 1; i < end; i++) {
//   //   lines[i] = lines[i].replaceAll(RegExp(r'\s'), '|');
//   // }
//   // if (end != -1) {
//   //   lines.insert(start, '```');
//   //   lines.insert(end + 1, '```'); // +1 because we inserted one line before
//   // }

//   return lines.join('\n');
// }
