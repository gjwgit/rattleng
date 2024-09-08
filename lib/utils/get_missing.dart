/// <DESCRIPTION>
//
// Time-stamp: <Thursday 2024-06-06 05:58:50 +1000 Graham Williams>
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

// Group imports by dart, flutter, packages, local. Then alphabetically.
import 'package:flutter_riverpod/flutter_riverpod.dart';

//import 'package:rattle/providers/roles.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/r/extract.dart';

List<String> getMissing(WidgetRef ref) {
  // // The rolesProvider lists the roles for the different variables which we
  // // need to know for parsing the R scripts.

  // Map<String, String> roles = ref.read(rolesProvider);

  // // Extract the input variable from the rolesProvider.

  // List<String> vars = [];
  // roles.forEach((key, value) {
  //   if (value == 'Input' || value == 'Risk' || value == 'Target') {
  //     vars.add(key);
  //   }
  // });

  // ONLY INCLUDE THOSE WITH MISSING VALUES.

  String stdout = ref.read(stdoutProvider);

  String missing = rExtract(stdout, '> missing');

  // Regular expression to match strings between quotes

  RegExp regExp = RegExp(r'"(.*?)"');

  // Find all matches

  Iterable<RegExpMatch> matches = regExp.allMatches(missing);

  // Extract the matched strings

  List<String> variables = matches.map((match) => match.group(1)!).toList();

  return variables;
}
