import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/providers/vars/roles.dart';




List<String> getInputs(WidgetRef ref) {
  // The rolesProvider lists the roles for the different variables which we
  // need to know for parsing the R scripts.

  Map<String, Role> roles = ref.read(rolesProvider);

  // Extract the input variable from the rolesProvider.

  List<String> inputs = [];
  roles.forEach((key, value) {
    if (value == Role.input) {
      inputs.add(key);
    }
  });

  return inputs;
}

List<String> getInputsAndIgnoreTransformed(WidgetRef ref) {
  // The rolesProvider lists the roles for the different variables which we
  // need to know for parsing the R scripts.

  Map<String, Role> roles = ref.read(rolesProvider);

  // Extract the input variable from the rolesProvider.

  List<String> inputs = [];
  roles.forEach((key, value) {
    if (value == Role.input || value == Role.ignoreAfterTransformed) {
      inputs.add(key);
    }
  });

  return inputs;
}
