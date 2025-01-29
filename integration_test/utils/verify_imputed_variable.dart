import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rattle/features/dataset/display.dart';
import 'package:rattle/providers/vars/roles.dart';

Future<void> verifyImputedVariable(
  WidgetTester tester,
  String variable,
) async {
  // get the roles from the dataset display.

  final roles = tester
      .state<ConsumerState>(
        find.byType(DatasetDisplay),
      )
      .ref
      .read(rolesProvider);

  List<String> vars = [];
  roles.forEach((key, value) {
    if (value == Role.input ||
        value == Role.risk ||
        value == Role.target ||
        value == Role.ignore) {
      vars.add(key);
    }
  });

  // check if the variable is in the list of variables.

  expect(vars.contains(variable), true);
}
