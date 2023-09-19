/// Utility to extract the latest decision tree from R log.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Wednesday 2023-09-20 09:08:09 +1000 Graham Williams>
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

import 'dart:io';

import 'package:intl/intl.dart';

import 'package:rattle/r/extract.dart';
import 'package:rattle/helpers/timestamp.dart';

/// Extract from the R [log] lines of output from the decision tree.

String rExtractTree(String log) {
  // ignore: prefer_interpolation_to_compose_strings

  String extract = "Summary of the Decision Tree model for Classification " +
      "(built using 'rpart'):" +
      "\n\n" +
      "Formula: " +
      rExtract(log, "> print(form)") +
      "\n\n" +
      rExtract(log, "> print(model_rpart)") +
      "\n" +
      rExtract(log, "> printcp(model_rpart)") +
      "\n\n" +
      "Rattle timestamp: " +
      timestamp();

  extract = extract.replaceAllMapped(
    RegExp(r'\nn= '),
    (match) {
      return '\nObservations = ';
    },
  );

  extract = extract.replaceAllMapped(
    RegExp(r'\n(Classification tree:)\n'),
    (match) {
      return '\n${match.group(1)}\n\n';
    },
  );

  // Nicely format the call to rpart.

  extract = extract.replaceAllMapped(
    RegExp(
      r'\n(rpart\(.*\))\)',
      multiLine: true,
      dotAll: true,
    ),
    (match) {
      // The first group is then the whole rpart(...) call.

      String txt = match.group(1) ?? "";

      txt = txt.replaceAll('\n', '');
      txt = txt.replaceAll(RegExp(r',\s*m'), ', m');

      txt = txt.replaceAllMapped(
        RegExp(r'(\w+)\s*=\s*([^,]+),'),
        (match) {
          return "\n    ${match.group(1)}=${match.group(2)},";
        },
      );

      txt = txt.replaceAll(' = ', '=');

      return "\n${txt}\n)";
    },
  );

  extract = extract.replaceAllMapped(
    RegExp(r'\n(Variables actually used in.*)\n'),
    (match) {
      return '\n${match.group(1)}\n\n';
    },
  );

  List<String> lines = extract.split('\n');

  List<String> result = [];

  for (int i = 0; i < lines.length; i++) {
    // if (lines[i].startsWith("Call:")) {
    //   continue;
    // }
    result.add(lines[i]);
  }

  return result.join('\n');
}
