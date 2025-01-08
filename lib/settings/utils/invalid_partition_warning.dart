/// Display a warning if the partition total is invalid when pressing cancel.

import 'package:flutter/material.dart';

void showInvalidPartitionWarning(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Invalid Partition Total'),
        content: const Text(
          'The total of Training, Validation, and Testing percentages must be exactly 100.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
