import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rattle/providers/roles.dart';
import 'package:rattle/r/extract_vars.dart';

void updateRolesProvider(List<VariableInfo> vars, WidgetRef ref) {
  // When a new row is added after transformation, initialise its role and update the role of the old variable
  for (var column in vars) {
    if (!ref.read(rolesProvider.notifier).state.containsKey(column.name)) {
      if (column.name.startsWith('RRC_') ||
          column.name.startsWith('R01_') ||
          column.name.startsWith('RMD_') ||
          column.name.startsWith('RLG_') ||
          column.name.startsWith('R10_')) {
        ref.read(rolesProvider.notifier).state[column.name] = Role.input;
        ref
                .read(rolesProvider.notifier)
                .state[column.name.substring(4)] =
            Role.ignoreAfterTransformed;
      } else {
        debugPrint('uninitialised new variables!');
      }
    }
  }
}
