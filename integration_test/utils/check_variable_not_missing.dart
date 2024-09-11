import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/r/extract.dart';

Future<void> checkVariableNotMissing(
    ProviderContainer container, String variable) async {
  final stdout = container.read(stdoutProvider);
  String missing = rExtract(stdout, '> missing');

  RegExp regExp = RegExp(r'"(.*?)"');
  Iterable<RegExpMatch> matches = regExp.allMatches(missing);
  List<String> variables = matches.map((match) => match.group(1)!).toList();

  expect(variables.contains(variable), false);
}
