import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rattle/providers/vars/roles.dart';

List<String> getIgnored(WidgetRef ref) {
  // The rolesProvider lists the roles for the different variables which we
  // need to know for parsing the R scripts.

  Map<String, Role> roles = ref.read(rolesProvider);

  // Extract the ignored variable from the rolesProvider.

  List<String> ignored = [];
  roles.forEach((key, value) {
    if (value == Role.ignore) {
      ignored.add(key);
    }
  });

  return ignored;
}
