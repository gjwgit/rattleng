import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rattle/providers/vars/roles.dart';

Future<void> verifyImputedVariable(
  ProviderContainer container,
  String variable,
) async {
  Map<String, Role> roles = container.read(rolesProvider);

  List<String> vars = [];
  roles.forEach((key, value) {
    if (value == Role.input ||
        value == Role.risk ||
        value == Role.target ||
        value == Role.ignore) {
      vars.add(key);
    }
  });

  expect(vars.contains(variable), true);
}
