import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rattle/providers/roles.dart';
import 'package:rattle/r/extract_vars.dart';

void updateRolesProvider(List<VariableInfo> vars, WidgetRef ref) {
  // When a new row is added after transformation, initialise its role and update the role of the old variable
  for (var column in vars) {
    if (!ref.read(rolesProvider.notifier).state.containsKey(column.name)) {
      if (column.name.startsWith('RRC_')) {
        ref.read(rolesProvider.notifier).state[column.name] = 'Input';
        ref
            .read(rolesProvider.notifier)
            .state[column.name.replaceFirst('RRC_', '')] = 'Ignore';
      } else {
        debugPrint('uninitialised new variables!');
      }
    }
  }
}
