/// A dialog to prompte user on closing app with SAVE and CANCEL options
///
/// Time-stamp: <Thursday 2024-11-14 09:22:33 +1100 Graham Williams>
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
/// Authors: Bo Zhang (Lutra-Fs), Graham Williams

library;

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rattle/providers/session_control.dart';
import 'package:window_manager/window_manager.dart';

import 'package:rattle/constants/temp_dir.dart';
import 'package:rattle/providers/script.dart';
import 'package:rattle/utils/debug_text.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';

const double widthSpace = 10;

class CloseDialog extends ConsumerStatefulWidget {
  const CloseDialog({super.key});

  @override
  ConsumerState<CloseDialog> createState() => _CloseDialogState();
}

class _CloseDialogState extends ConsumerState<CloseDialog> {
  String _title = 'Close Rattle?';

  String _content = wordWrap('''

    Are you sure you want to close Rattle?
    Unsaved changes will be lost. 
    You can save the script now before closing.

    ''');

  @override
  Widget build(BuildContext context) {
    // Check the sessionControlProvider state.

    final sessionControl = ref.watch(sessionControlProvider);

    if (!sessionControl) {
      // If session control is OFF, close the app directly.

      _closeApp();
      return const SizedBox.shrink();
    }

    // If session control is ON, show the confirmation dialog.

    return AlertDialog(
      title: Row(
        children: [
          const Icon(
            Icons.close,
            size: 24,
            color: Colors.blue,
          ),
          const SizedBox(width: widthSpace),
          Text(_title),
        ],
      ),
      content: Text(_content),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        // Conditionally display the Save button

        if (_title != 'Script saved')
          TextButton(
            onPressed: () => _showFileNameDialog(context),
            child: const Text('Save'),
          ),
        TextButton(
          onPressed: _closeApp,
          child: const Text('Close'),
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
        _content = wordWrap(
          '''

          No file selected.  You can still close the app or try saving the
          script again.

            ''',
        );
      });
    }
  }

  void _saveScript(String fileName) {
    debugText('  SAVE ON CLOSE', fileName);

    String script = ref.read(scriptProvider);
    script = _cleanScript(script);

    if (!fileName.endsWith('.R')) {
      fileName = '$fileName.R';
    }

    File(fileName).writeAsString(script);

    setState(() {
      _title = 'Script saved';
      _content = wordWrap('''

        The script has been saved to the following R file
        $fileName.\nYou can now close the app.

        ''');
    });
  }

  String _cleanScript(String script) {
    return script
        .split('\n')
        .where(
          (line) =>
              !line.trim().startsWith('svg') &&
              !line.trim().startsWith('dev.off'),
        )
        .join('\n');
  }
}

Future<void> cleanUpTempDirs() async {
  final rattleTempDir = Directory(tempDir);

  if (await rattleTempDir.exists()) {
    await rattleTempDir.delete(recursive: true);

    debugText('  DELETED', tempDir);
  }
}
