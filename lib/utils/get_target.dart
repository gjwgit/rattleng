/// Identify a target variable.
//
// Time-stamp: <Monday 2024-12-16 08:18:30 +1100 Graham Williams>
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

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/providers/stdout.dart';
import 'package:rattle/providers/vars/roles.dart';
import 'package:rattle/r/extract.dart';

String getTarget(WidgetRef ref) {
  // The rolesProvider lists the roles for the different variables which we
  // need to know for parsing the R scripts.

  Map<String, Role> roles = ref.read(rolesProvider);

  // Extract the target variable from the rolesProvider.

  String target = 'NULL';
  roles.forEach((key, value) {
    if (value == Role.target) {
      target = key;
    }
  });

  if (target == 'NULL') {
    String stdout = ref.watch(stdoutProvider);

    String defineTarget = rExtract(stdout, 'find_fewest_levels(ds)');

    defineTarget = defineTarget.replaceAll(RegExp(r'^ *\[[^\]]\] '), '');

    // Removes matching quotes from the start and end of a string.

    if ((defineTarget.startsWith("'") && defineTarget.endsWith("'")) ||
        (defineTarget.startsWith('"') && defineTarget.endsWith('"'))) {
      if (defineTarget.length >= 3) {
        defineTarget = defineTarget.substring(1, defineTarget.length - 1);
      }
    }

    if (defineTarget.isNotEmpty && target != '""') {
      return defineTarget;
    }
  }

  return target;
}
