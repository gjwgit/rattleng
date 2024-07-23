import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/providers/stdout.dart';
import 'package:rattle/r/extract.dart';

List<String> getUniqueColumns(WidgetRef ref) {
  String stdout = ref.watch(stdoutProvider);

  String uniqueColumns = rExtract(stdout, 'unique_columns(ds)');

  uniqueColumns = uniqueColumns.replaceAll(RegExp(r'^ *\[[^\]]\] '), '');

  // Extract the ids from the output of unique_columns().

  RegExp regExp = RegExp(r'"(.*?)"');
  Iterable<Match> matches = regExp.allMatches(uniqueColumns);
  List<String> ids = matches.map((match) => match.group(1)!).toList();

  return ids;
}
