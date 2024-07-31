import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rattle/providers/roles.dart';
import 'package:rattle/r/extract_vars.dart';

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

void updateRolesProvider(List<VariableInfo> vars, WidgetRef ref) {
  // When a new row is added after transformation, initialise its role and update the role of the old variable
  for (var column in vars) {
    if (!ref.read(rolesProvider.notifier).state.containsKey(column.name)) {
      if (isTransformedVar(column.name)) {
        ref.read(rolesProvider.notifier).state[column.name] = Role.input;
        ref.read(rolesProvider.notifier).state[column.name.substring(4)] =
            Role.ignoreAfterTransformed;
      } else {
        debugPrint('uninitialised new variables!');
      }
    }
  }
}
