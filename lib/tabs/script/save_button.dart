/// A button to save the script to file.
///
/// Time-stamp: <Sunday 2024-09-08 13:47:58 +1000 Graham Williams>
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU General Public License as published by the Free Software
// Foundation, either version 3 of the License, or (at your option) any later
// version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program.  If not, see <https://www.gnu.org/licenses/>.
///
/// Authors: Graham Williams, Yixiang Yin
library;

import 'dart:io' show File;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:file_picker/file_picker.dart';
import 'package:rattle/constants/spacing.dart';

import 'package:rattle/providers/script.dart';

class ScriptSaveButton extends ConsumerWidget {
  const ScriptSaveButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      child: const Text('Save'),
      onPressed: () {
        _showFileNameDialog(context, ref);
      },
    );
  }

  // Function to display a dialog for the user to enter the file name.
  Future<void> _showFileNameDialog(BuildContext context, WidgetRef ref) async {
    String? outputPath = await FilePicker.platform.saveFile(
      dialogTitle: 'Provide a .R filename to save the R script to',
      fileName: 'script.R',
      type: FileType.custom,
      allowedExtensions: ['R'],
    );
    if (context.mounted) {
      if (outputPath != null) {
        // User picked a file.
        _saveScript(ref, outputPath, context);
      } else {
        // user canceled the file picker
        _showErrorDialog(context, 'No file selected');
      }
    } else {
      // The context is no longer mounted.
      debugPrint('ERROR: Context is no longer mounted');
    }

    return;
  }

  // Function to display an error dialog.

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              // Error icon.

              const Icon(Icons.error, color: Colors.red),
              rowGap,
              const Text('Error'),
            ],
          ),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Function to save the script to a file.
  void _saveScript(WidgetRef ref, String fileName, BuildContext context) {
    debugPrint("SAVE BUTTON EXPORT: '$fileName'");

    // Get the script content from the provider.
    String script = ref.read(scriptProvider);

    // Remove the lines starting with 'svg' and 'dev.off'
    List<String> lines = script.split('\n');
    lines = lines.where((line) => !line.trim().startsWith('svg')).toList();
    lines = lines.where((line) => !line.trim().startsWith('dev.off')).toList();
    script = lines.join('\n');

    if (!fileName.endsWith('.R')) {
      fileName = '$fileName.R';
    }
    final file = File(fileName);

    // Write the script content to the file.
    file.writeAsString(script);

    // Show a confirmation message.
    final filePath = file.absolute.path;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('R script file saved as $filePath')),
    );
  }
}
