/// Utility to extract the latest names(ds) output from R.
///
/// Copyright (C) 2023-2025, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://opensource.org/license/gpl-3-0
//
// Time-stamp: "Wednesday 2025-09-10 12:52:05 +1000 Graham Williams"
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
// this program.  If not, see <https://opensource.org/license/gpl-3-0>.
///
/// Authors: Graham Williams

library;

import 'package:rattle/r/extract.dart';

// TODO 20250409 RENAME THIS AS rExtractVars In LINE WITH FILE NAME

List<VariableInfo> extractVariables(String txt) {
  // TODO 20250409 MIGRATE TO meta_data RATHER THAN `glimpse()`.

  // Extract the variable information from the latest glimpse(ds)

  String cmd = '> glimpse(ds)';
  String vars = rExtract(txt, cmd);

  // Rgex to capture variable names with special characters like '&'.
  // It captures any characters non-greedily between '$ ' and ' <type>'.

  final regex = RegExp(r'\$\s+([^<]+?)\s+<([^>]+)>\s+(.+)', multiLine: true);
  final matches = regex.allMatches(vars);

  return matches.map((match) {
    // Trim potential trailing whitespace from the captured name.

    var name = match.group(1)!.trim();
    final type = match.group(2)!.trim();
    final details = match.group(3)!.trim();

    // Check if the name is wrapped in quotes and contains no internal whitespace.

    if ((name.startsWith('"') && name.endsWith('"')) ||
        (name.startsWith('\'') && name.endsWith('\'')) ||
        (name.startsWith('`') && name.endsWith('`'))) {
      // Extract the content inside the quotes.

      var innerName = name.substring(1, name.length - 1);
      // Remove quotes only if there's no whitespace inside.

      if (!innerName.contains(RegExp(r'\s'))) {
        name = innerName;
      }
    }

    return VariableInfo(name: name, type: type, details: details);
  }).toList();
}

class VariableInfo {
  final String name;
  final String type;
  final String details;

  VariableInfo({required this.name, required this.type, required this.details});
}
