import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/providers/stdout.dart';
import 'package:rattle/r/extract.dart';

void updateMetaData(WidgetRef ref) {
  debugPrint('UPDATE MEAT DATA');

  String stdout = ref.watch(stdoutProvider);

  String content = rExtract(stdout, '> meta_data(ds)');

  print(content);
}
