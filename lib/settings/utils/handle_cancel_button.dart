/// Validate partition total when pressing cancel button.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rattle/providers/settings.dart';
import 'package:rattle/settings/utils/invalid_partition_warning.dart';

void handleCancelButton(BuildContext context, WidgetRef ref) {
  final train = ref.read(partitionTrainProvider);
  final valid = ref.read(partitionTuneProvider);
  final test = ref.read(partitionTestProvider);
  final total = train + valid + test;

  if (total != 100) {
    showInvalidPartitionWarning(context);
  } else {
    Navigator.of(context).pop();
  }
}
