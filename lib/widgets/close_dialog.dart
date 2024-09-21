/// The dialog that will be prompted when the user tries to close the app.
///
/// Time-stamp: <Leave as BLANK for now>
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
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
/// Authors: Bo Zhang(Lutra-Fs)

library;

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/temp_dir.dart';
import 'package:rattle/providers/script.dart';

import 'package:file_picker/file_picker.dart';
import 'package:window_manager/window_manager.dart';

class CloseDialog extends ConsumerStatefulWidget {
  const CloseDialog({super.key});

  @override
  ConsumerState<CloseDialog> createState() => _CloseDialogState();
}

class _CloseDialogState extends ConsumerState<CloseDialog> {
  String _title = 'Close Rattle?';
  String _content =
      'Are you sure you want to close Rattle? All unsaved changes will be lost. You could save the script before closing. Note that the Save button will not close the app after saving.';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_title),
      content: Text(_content),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _closeApp,
          child: const Text('Close'),
        ),
        TextButton(
          onPressed: () => _showFileNameDialog(context),
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _closeApp() {
    Navigator.of(context).pop();
    cleanUpTempDirs();
    WindowManager.instance.setPreventClose(false);
    WindowManager.instance.close();
  }

  Future<void> _showFileNameDialog(BuildContext context) async {
    final outputPath = await FilePicker.platform.saveFile(
      dialogTitle: 'Provide a .R filename to save the R script to',
      fileName: 'script.R',
      type: FileType.custom,
      allowedExtensions: ['R'],
    );

    if (!mounted) return;

    if (outputPath != null) {
      _saveScript(outputPath);
    } else {
      setState(() {
        _title = 'Error';
        _content =
            'No file selected, you could either close the app or save the script again.';
      });
    }
  }

  void _saveScript(String fileName) {
    debugPrint("SAVE BUTTON EXPORT: '$fileName'");

    String script = ref.read(scriptProvider);
    script = _cleanScript(script);

    if (!fileName.endsWith('.R')) {
      fileName = '$fileName.R';
    }

    File(fileName).writeAsString(script);

    setState(() {
      _title = 'Script saved';
      _content =
          'The script has been saved to $fileName. You can now close the app.';
    });
  }

  String _cleanScript(String script) {
    return script
        .split('\n')
        .where((line) =>
            !line.trim().startsWith('svg') &&
            !line.trim().startsWith('dev.off'),)
        .join('\n');
  }
}

Future<void> cleanUpTempDirs() async {
  final rattleTempDir = Directory(tempDir);
  if (await rattleTempDir.exists()) {
    await rattleTempDir.delete(recursive: true);
    debugPrint('Deleted Rattle temp directory: $tempDir');
  }
}
