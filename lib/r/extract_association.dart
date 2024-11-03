/// Utility to extract the ASSOCIATION RULES from R log.
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Friday 2024-09-27 05:39:57 +1000 Graham Williams>
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
import 'package:rattle/utils/timestamp.dart';

String _basicTemplate(String log, bool isSummary) {
  String hd = isSummary
      ? 'Summary of the Association Rules'
      : 'Interestingness Measures';
  const String md = "(built using 'apriori'):";
  final String sm = rExtract(
    log,
    isSummary ? '> print(summary(model_arules))' : '> print(measures)',
  );

  final String ts = timestamp();

  String result = '';

  if (sm != '') {
    result = '$hd $md\n$sm\n\nRattle timestamp: $ts';
  }

  return result;
}

/// Extract from the R [log] lines of output.

String rExtractAssociation(String log, bool isSummary) {
  String extract = _basicTemplate(log, isSummary);

  extract = extract.replaceAllMapped(
    RegExp(r'\nn= '),
    (match) {
      return '\nObservations = ';
    },
  );

  // Nicely format the call.

  extract = extract.replaceAllMapped(
    RegExp(
      r'\n(\(.*\))\)',
      multiLine: true,
      dotAll: true,
    ),
    (match) {
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

  return extract;
}
