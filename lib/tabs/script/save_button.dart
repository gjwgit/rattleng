/// A button to save the script to file.
///
/// Time-stamp: <Monday 2025-01-06 07:10:54 +1100 Graham Williams>
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
import 'package:markdown_tooltip/markdown_tooltip.dart';

import 'package:rattle/constants/temp_dir.dart';
import 'package:rattle/providers/script.dart';
import 'package:rattle/providers/settings.dart';

class ScriptSaveButton extends ConsumerWidget {
  const ScriptSaveButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Button to save as R script.

    return MarkdownTooltip(
      message: '''

      **Save.** Tap here to save the information in this text
          page to a **R script** document.

      ''',
      child: IconButton(
        onPressed: () {
          _showFileNameDialog(context, ref);
        },
        icon: Icon(
          Icons.save,
          color: Colors.blue,
        ),
      ),
    );
  }

  // Display a dialog for the user to enter the file name.

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
        bool stripComments = ref.read(stripCommentsProvider);
        _saveScript(ref, outputPath, context, stripComments);
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

  // Display an error dialog.

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
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

  // Save the script to a file.

  void _saveScript(WidgetRef ref, String fileName, BuildContext context,
      bool stripComments) {
    debugPrint("SAVE BUTTON EXPORT: '$fileName'");
    // Get the script content from the provider.

    String script = ref.read(scriptProvider);
    // 20250106 gjw Remove the lines starting with 'svg' and 'dev.off' since the
    // final user script will generally not have access to the tmpdir and the
    // user will generally want to see the plots rather than immediately save
    // them to file. 20250106 gjw Also remove any lines starting with rat as
    // they are Rattle versions of cat used for communicating to Rattle rather
    // than for user messages.

    List<String> lines = script.split('\n');
    lines = lines.where((line) => !line.trim().startsWith('svg')).toList();
    lines = lines.where((line) => !line.trim().startsWith('dev.off')).toList();
    lines = lines.where((line) => !line.trim().startsWith('rat <-')).toList();
    lines = lines.where((line) => !line.trim().startsWith('rat(')).toList();
    lines = lines.map((line) => line.replaceAll(tempDir + '/', '')).toList();

    if (stripComments) {
      // Remove R comments (lines starting with #)
      lines = lines.where((line) => !line.trim().startsWith('#')).toList();
      // Remove blank lines
      lines = lines.where((line) => line.trim().isNotEmpty).toList();
    }

    script = lines.join('\n');

    if (!fileName.endsWith('.R')) {
      fileName = '$fileName.R';
    }
    final file = File(fileName);

    file.writeAsString(script);

    final filePath = file.absolute.path;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('R script file saved as $filePath')),
    );
  }
}
