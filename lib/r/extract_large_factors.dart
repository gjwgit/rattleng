/// Utility to extract the large factors output from R.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Sunday 2024-05-19 07:07:31 +1000 Graham Williams>
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
/// Authors: Zheyuan Xu
library;

import 'package:rattle/r/extract.dart';

List<String> extractLargeFactors(String txt) {
  // Command used to locate the variable definitions in the text.

  String cmd = '> large_factor_vars';

  // Extract the variables string from the text based on the command.

  String vars = rExtract(txt, cmd);

  // Regular expression to find all variable names enclosed in double quotes.

  RegExp regExp = RegExp(r'"(.*?)"');

  // Find all matches of the regular expression in the vars string.

  Iterable<Match> matches = regExp.allMatches(vars);

  List<String> variableList = matches.map((match) => match.group(1)!).toList();

  return variableList;
}
