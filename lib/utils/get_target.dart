import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/providers/stdout.dart';
import 'package:rattle/providers/vars/roles.dart';
import 'package:rattle/r/extract.dart';

String getTarget(WidgetRef ref) {
// The rolesProvider listes the roles for the different variables which we
  // need to know for parsing the R scripts.

  Map<String, Role> roles = ref.read(rolesProvider);

  // Extract the target variable from the rolesProvider.

  String target = 'NULL';
  roles.forEach((key, value) {
    if (value == Role.target) {
      target = key;
    }
  });

  if (target == 'NULL') {
    String stdout = ref.watch(stdoutProvider);

    String defineTarget = rExtract(stdout, 'find_fewest_levels(ds)');

    defineTarget = defineTarget.replaceAll(RegExp(r'^ *\[[^\]]\] '), '');

    // Removes matching quotes from the start and end of a string.

    if ((defineTarget.startsWith("'") && defineTarget.endsWith("'")) ||
        (defineTarget.startsWith('"') && defineTarget.endsWith('"'))) {
      if (defineTarget.length >= 3) {
        defineTarget = defineTarget.substring(1, defineTarget.length - 1);
      }
    }

    if (defineTarget.isNotEmpty) {
      return defineTarget;
    }
  }

  return target;
}
