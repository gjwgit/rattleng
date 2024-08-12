import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/r/extract.dart';

String? getObsMissing(WidgetRef ref) {
  String stdout = ref.read(stdoutProvider);

  String missing = rExtract(stdout, '> nmobs');
  RegExp regExp = RegExp(r'\[\d+\]\s(\d+)');

  // Extracting the matched number
  String? extractedNumber = regExp.firstMatch(missing)?.group(1);

  return extractedNumber;
}
