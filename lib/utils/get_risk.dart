import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/providers/roles.dart';

String getRisk(WidgetRef ref) {
// The rolesProvider listes the roles for the different variables which we
  // need to know for parsing the R scripts.

  Map<String, Role> roles = ref.read(rolesProvider);

  // Extract the risk variable from the rolesProvider.

  String risk = 'NULL';
  roles.forEach((key, value) {
    if (value == Role.risk) {
      risk = key;
    }
  });

  return risk;
}
