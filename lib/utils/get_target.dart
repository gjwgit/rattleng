import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/providers/roles.dart';

String getTarget(WidgetRef ref) {
// The rolesProvider listes the roles for the different variables which we
  // need to know for parsing the R scripts.

  Map<String, Role> roles = ref.read(rolesProvider);

  // Extract the target variable from the rolesProvider.

  String target = 'NULL';
  roles.forEach((key, value) {
    if (value ==  Role.target) {
      target = key;
    }
  });

  return target;
}
