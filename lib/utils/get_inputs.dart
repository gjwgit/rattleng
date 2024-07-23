import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/providers/roles.dart';

List<String> getInputs(WidgetRef ref) {
  // The rolesProvider lists the roles for the different variables which we
  // need to know for parsing the R scripts.

  Map<String, String> roles = ref.read(rolesProvider);

  // Extract the input variable from the rolesProvider.

  List<String> inputs = [];
  roles.forEach((key, value) {
    if (value == 'Input') {
      inputs.add(key);
    }
  });

  return inputs;
}
