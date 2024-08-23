/// Update variable state in flutter based on its state in R
//
// Time-stamp: <Thursday 2024-08-15 07:17:53 +1000 Graham Williams>
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

import 'package:rattle/providers/vars/roles.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/providers/vars/types.dart';
import 'package:rattle/r/extract_vars.dart';
import 'package:rattle/utils/is_numeric.dart';

// Define the prefixes that need special handling. They have an number at suffix
Set<String> specialPrefixes = {
  'RIN',
  'BK',
  'BQ',
  'BE',
};

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
  'BK', // number at suffix
  'BQ', // number at suffix
  'BE', // number at suffix
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
  // It should return the var name before the transformation given the var name after the transformation
  // Define the prefixes that need special handling
  final List<String> specialPrefixes = ['RIN', 'BK', 'BQ', 'BE'];

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
  // When a new row is added after transformation, initialise its role and update the role of the old variable
  for (var column in vars) {
    // update roles
    if (!ref.read(rolesProvider.notifier).state.containsKey(column.name)) {
      if (isTransformedVar(column.name)) {
        ref.read(rolesProvider.notifier).state[column.name] = Role.input;
        ref.read(rolesProvider.notifier).state[getOriginal(column.name)] =
            Role.ignoreAfterTransformed;
      } else {
        debugPrint('ERROR: unidentified variables: ${column.name}!');
      }
    }
    // update types
    if (!ref.read(typesProvider.notifier).state.containsKey(column.name)) {
      ref.read(typesProvider.notifier).state[column.name] =
          isNumeric(column.type) ? Type.numeric : Type.categoric;
    }
  }
}

// t -> delete succeed
// f -> try to delete var which doesn't exist
bool deleteVar(WidgetRef ref, String v) {
  Role? r = ref.read(rolesProvider.notifier).state.remove(v);
  Type? t = ref.read(typesProvider.notifier).state.remove(v);
  if (r == null) {
    debugPrint(
      'ERROR: attempt to delete $v from roles but $v is not found in the map.',
    );

    return false;
  } else if (t == null) {
    debugPrint(
      'ERROR: attempt to delete $v from types but $v is not found in the map.',
    );

    return false;
  }
  
  return true;
}
