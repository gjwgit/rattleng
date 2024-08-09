import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//import 'package:rattle/providers/roles.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/r/extract.dart';

List<String> getMissing(WidgetRef ref) {
  // // The rolesProvider lists the roles for the different variables which we
  // // need to know for parsing the R scripts.

  // Map<String, String> roles = ref.read(rolesProvider);

  // // Extract the input variable from the rolesProvider.

  // List<String> vars = [];
  // roles.forEach((key, value) {
  //   if (value == 'Input' || value == 'Risk' || value == 'Target') {
  //     vars.add(key);
  //   }
  // });

  // ONLY INCLUDE THOSE WITH MISSING VALUES.

  String stdout = ref.read(stdoutProvider);

  String missing = rExtract(stdout, '> missing');

  // Regular expression to match strings between quotes

  RegExp regExp = RegExp(r'"(.*?)"');

  // Find all matches

  Iterable<RegExpMatch> matches = regExp.allMatches(missing);

  // Extract the matched strings

  List<String> variables = matches.map((match) => match.group(1)!).toList();
  debugPrint('from get_missing Missing vars: $variables');

  return variables;
}
