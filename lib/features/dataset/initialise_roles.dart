/// Initialise variable roles.
///
// Time-stamp: "Wednesday 2025-09-17 09:04:16 +1000 Graham Williams"
///
/// Copyright (C) 2025, Togaware Pty Ltd
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://opensource.org/license/gpl-3-0
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
// this program.  If not, see https://opensource.org/license/gpl-3-0.
///
/// Authors: Graham Williams

library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/providers/meta_data.dart';
import 'package:rattle/providers/vars/roles.dart';
import 'package:rattle/providers/vars/types.dart';
import 'package:rattle/r/extract_vars.dart';
import 'package:rattle/utils/get_target.dart';
import 'package:rattle/utils/get_unique_columns.dart';
import 'package:rattle/utils/is_numeric.dart';

// Set initial role for a variable.

void _setInitialRole(VariableInfo column, WidgetRef ref) {
  String name = column.name.toLowerCase();

  // Default is INPUT unless a prefix is found.

  Role role = Role.input;

  if (name.startsWith('risk_')) role = Role.risk;
  if (name.startsWith('ignore_')) role = Role.ignore;
  if (name.startsWith('target_')) role = Role.target;

  ref.read(rolesProvider.notifier).state[column.name] = role;
  ref.read(typesProvider.notifier).state[column.name] =
      isNumeric(column.type) ? Type.numeric : Type.categoric;
}

// Treat the last variable as a TARGET by default. We will eventually
// implement Rattle heuristics to identify the TARGET if the final
// variable has more than 5 levels. If so we'll check if the first
// variable looks like a TARGET (another common practise) and if not
// then no TARGET will be identified by default.

void _setTargetRole(List<VariableInfo> vars, WidgetRef ref) {
  String target = getTarget(ref);

  if (target == 'NULL') {
    ref.read(rolesProvider.notifier).state[vars.last.name] = Role.target;
  } else if (target != '""') {
    // TODO 20241216 gjw HOW DOES target BECOME '""' - TO BE FIXED.

    ref.read(rolesProvider.notifier).state[target] = Role.target;
  }
}

void _setIdentRole(WidgetRef ref) {
  // Any variables that have a unique value for every row in the dataset is
  // considered to be an IDENTifier.

  for (var id in getUniqueColumns(ref)) {
    ref.read(rolesProvider.notifier).state[id] = Role.ident;
  }

  Map metaData = ref.read(metaDataProvider);

  // 20241211 gjw A hueristic that says if there are only two columns in the
  // dataset, expect it to be a basket dataset for association rule
  // analysis. Set the firt column as the basket identifier (IDENT) and the
  // second column as the basket item (TARGET). As we move away from the
  // DATASET tab we also set the BASKETS checkbox in the ASSOCIATE feature to
  // match this heuristic. That is done in `lib/home.dart`.

  if (metaData.length == 2) {
    ref.read(rolesProvider.notifier).state[metaData.keys.first] = Role.ident;
    ref.read(rolesProvider.notifier).state[metaData.keys.last] = Role.target;
  }
}

// Initialize roles.

void initialiseRoles(
  List<VariableInfo> vars,
  List<String> highVars,
  Map<String, Role> currentRoles,
  WidgetRef ref,
) {
  if (currentRoles.isEmpty && vars.isNotEmpty) {
    for (var column in vars) {
      _setInitialRole(column, ref);
    }
    _setTargetRole(vars, ref);
    _setIdentRole(ref);

    // 20241213 gjw Let's turn off the IGNORE heursitic for now. Leave it to a
    // user to decide. For the PROTEIN dataset we want COUNTRY to be IDENT r
    // TARGET rather than IGNORE.

    // _setIgnoreRoleForHighVars(highVars, ref);
  }
}
