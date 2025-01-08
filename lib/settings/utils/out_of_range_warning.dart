/// Display a warning if a value is out of the valid range (0-100).

import 'package:flutter/material.dart';

void showOutOfRangeWarning(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Invalid Input'),
        content: const Text('Values must be between 0 and 100.'),
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
