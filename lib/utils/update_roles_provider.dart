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

void updateVariablesProvider(WidgetRef ref) {
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
      ref.read(typesProvider.notifier).state[column.name] = isNumeric(column.type) ? Type.numeric : Type.categoric;
    }
  }
}
