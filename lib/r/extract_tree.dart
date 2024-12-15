/// Utility to extract the latest decision tree from R log.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Monday 2024-12-16 08:20:57 +1100 Graham Williams>
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

import 'package:rattle/r/extract.dart';
import 'package:rattle/r/extract_formula.dart.~2~';
import 'package:rattle/utils/timestamp.dart';

String _basicTemplate(String log) {
  const String hd = 'Summary of the Decision Tree model for Classification';
  const String md = "(built using 'rpart'):";
  final String fm = rExtractFormula(log);
  final String pr = rExtract(log, '> print(model_rpart)');
  final String cp = rExtract(log, '> printcp(model_rpart)');
  final String ts = timestamp();

  String result = '';

  if (pr != '') {
    result = '$hd $md\n\nFormula: $fm\n\n$pr\n$cp\n\nRattle timestamp: $ts';
  }

  return result;
}

/// Extract from the R [log] lines of output from the decision tree.

String rExtractTree(String log) {
  String extract = _basicTemplate(log);

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

      String txt = match.group(1) ?? '';

      txt = txt.replaceAll('\n', '');
      txt = txt.replaceAll(RegExp(r',\s*m'), ', m');

      txt = txt.replaceAllMapped(
        RegExp(r'(\w+)\s*=\s*([^,]+),'),
        (match) {
          return '\n    ${match.group(1)}=${match.group(2)},';
        },
      );

      txt = txt.replaceAll(' = ', '=');

      return '\n$txt\n)';
    },
  );

  extract = extract.replaceAllMapped(
    RegExp(r'\n(Variables actually used in.*)\n'),
    (match) {
      return '\n${match.group(1)}\n\n';
    },
  );

  return extract;
}
