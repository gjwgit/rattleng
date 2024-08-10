import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rattle/providers/vars/roles.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/providers/vars/types.dart';
import 'package:rattle/r/extract_vars.dart';
import 'package:rattle/utils/is_numeric.dart';

Set<String> transformPrefix = {
// rescale
  'RRC',
  'R01',
  'RMD',
  'RLG',
  'R10',
  'RRK',
  'RIN',
// Impute
  'IZR',
  'IMN',
  'IMD',
  'IMO',
  'IMP',
};

bool isTransformedVar(String name) {
  for (var prefix in transformPrefix) {
    if (name.startsWith('${prefix}_')) {
      return true;
    }
  }

  return false;
}

// TODO why don't we reset and update provider
// This function should be run after the R state has changed.
// It relies on the R to print its latest state with glimpse(ds).
// This should be idempotent

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
        ref.read(rolesProvider.notifier).state[column.name.substring(4)] =
            Role.ignoreAfterTransformed;
      } else {
        debugPrint('uninitialised new variables!');
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
    return false;
  } else if (t == null) {
    return false;
  }
  return true;
}
