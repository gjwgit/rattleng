/// Update variable state in flutter based on its state in R
//
// Time-stamp: <Friday 2024-12-20 14:58:58 +1100 Graham Williams>
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
/// Authors: Yixiang Yin, Graham Williams

library;

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/providers/selected.dart';
import 'package:rattle/providers/selected2.dart';
import 'package:rattle/providers/vars/roles.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/providers/vars/types.dart';
import 'package:rattle/r/extract_vars.dart';
import 'package:rattle/utils/is_numeric.dart';

// Define the prefixes that need special handling. They have an number at suffix
final List<String> specialPrefixes = ['RIN', 'BKM', 'BQT', 'BEQ'];

Set<String> transformPrefix = {
// rescale
  'RRC',
  'R01',
  'RMD',
  'RLG',
  'R10',
  'RRK',
  'RIN', // number at suffix
// Impute
  'IZR',
  'IMN',
  'IMD',
  'IMO',
  'IMP',
// Recode
  'BKM', // number at suffix
  'BQT', // number at suffix
  'BEQ', // number at suffix
  'TJN',
  'TIN',
};

bool isTransformedVar(String name) {
  for (var prefix in transformPrefix) {
    if (name.startsWith('${prefix}_')) {
      return true;
    }
  }

  return false;
}

String getOriginal(String input) {
  // It should return the variable name before the transformation given the variable name after the transformation

  // Find the index of the first underscore
  int firstUnderscoreIndex = input.indexOf('_');

  // If no underscore is found, return the original string
  if (firstUnderscoreIndex == -1) {
    return input;
  }

  // Extract the prefix from the input string
  String prefix = input.substring(0, firstUnderscoreIndex);

  // Remove everything before and including the first underscore
  String result = input.substring(firstUnderscoreIndex + 1);

  // If the prefix is in the list of special prefixes, handle the suffix
  if (specialPrefixes.contains(prefix)) {
    int lastUnderscoreIndex = result.lastIndexOf('_');
    if (lastUnderscoreIndex != -1) {
      // Remove the last underscore and everything after it
      result = result.substring(0, lastUnderscoreIndex);
    }
  }

  return result;
}

void updateVariablesProvider(WidgetRef ref) {
  // reset the rolesProvider and typesProvider
  // ref.read(rolesProvider.notifier).state = {};
  // ref.read(typesProvider.notifier).state = {};
  // get the most recent vars information from glimpse and update the information in roles provider and types provider
  String stdout = ref.watch(stdoutProvider);
  List<VariableInfo> vars = extractVariables(stdout);

  // 20241213 gjw Remove this for now. It was used for determining IGNORE roles
  // but due to an issues iwth that (see other comments) it is no longer being
  // done.

  // List<String> highVars = extractLargeFactors(stdout);

  // When a new row is added after transformation, initialise its role and update the role of the old variable
  for (var column in vars) {
    // update roles
    if (!ref.read(rolesProvider.notifier).state.containsKey(column.name)) {
      if (isTransformedVar(column.name)) {
        // update the old variable's role.

        ref.read(rolesProvider.notifier).state[column.name] = Role.input;
        // update the new variable's role.

        ref.read(rolesProvider.notifier).state[getOriginal(column.name)] =
            Role.ignoreAfterTransformed;
      } else {
        debugPrint('ERROR: unidentified variables: ${column.name}!');
      }
    }

    // Update the types.

    if (!ref.read(typesProvider.notifier).state.containsKey(column.name)) {
      ref.read(typesProvider.notifier).state[column.name] =
          isNumeric(column.type) ? Type.numeric : Type.categoric;
    }

    // 20241213 gjw Remove this heuristic for now. It is causing the IGNORE of
    // country in the PROTEIN dataset to be retained even if I change it to
    // INPUT/RISK/IDENT. Not if I change it to TARGET as per the test below. It
    // should actually be IDENT or TARGET.

    // 20241213 gjw This is repeated code from dataset/display.dart - we should
    // avoid repeated code as it is harder to maintain as I have just
    // demonstrated - I had to find this in two places to fix :-)

    // for (var highVar in highVars) {
    //   if (ref.read(rolesProvider.notifier).state[highVar] != Role.target) {
    //     ref.read(rolesProvider.notifier).state[highVar] = Role.ignore;
    //   }
    // }
  }
}

// t -> delete succeed
// f -> try to delete var which doesn't exist
bool deleteVar(WidgetRef ref, String v) {
  Role? r = ref.read(rolesProvider.notifier).state.remove(v);
  Type? t = ref.read(typesProvider.notifier).state.remove(v);
  String selected = ref.read(selectedProvider);
  String selected2 = ref.read(selected2Provider);

  if (selected == v) {
    ref.read(selectedProvider.notifier).state = 'NULL';
  }
  if (selected2 == v) {
    ref.read(selected2Provider.notifier).state = 'NULL';
  }

  if (r == null) {
    debugPrint('ERROR: Attempt to delete $v from ROLES but not in the map.');

    return false;
  } else if (t == null) {
    debugPrint('ERROR: Attempt to delete $v from TYPES but not in the map.');

    return false;
  }

  return true;
}
