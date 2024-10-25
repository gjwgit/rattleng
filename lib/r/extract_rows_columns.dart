/// Utility to extract the number of rows and columns from R.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Friday 2024-10-25 08:25:34 +1100 Graham Williams>
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

String rExtractRowsColumns(String txt) {
  // If it appears that R has not yet finished loading the dataset then return
  // an appropriate message.

  // if (txt.contains("Error: object 'ds' not found")) {
  //   return ('The dataset appears to still be loading. Please wait.');
  // }

  if (txt.isEmpty) return '';

  // Split the string into lines.

  List<String> lines = txt.split('\n');
  txt = '${lines.first} ${lines[1]}';

  RegExp regExp = RegExp(r'[\d,]+');
  Iterable<Match> matches = regExp.allMatches(txt);

  // Extract the numbers and format them.

  List<String?> numbers = matches.map((match) => match.group(0)).toList();

  String result = '';

  if (numbers.length >= 2) {
    result = '${numbers.first} x ${numbers[1]}';
  }

  return result;
}
