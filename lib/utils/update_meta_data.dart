import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/providers/stdout.dart';
import 'package:rattle/r/extract.dart';

void updateMetaData(WidgetRef ref) {
  String stdout = ref.watch(stdoutProvider);

  String content = rExtract(stdout, '> meta_data(ds)');

  debugPrint('META DATA:\nXXXXXXXXXX\n$content\nXXXXXXXXXX');
}
