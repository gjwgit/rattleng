/// A dialog to prompte user on closing app with SAVE and CANCEL options
///
/// Time-stamp: "Sunday 2025-03-30 07:51:28 +1100 Graham Williams"
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://opensource.org/license/gpl-3-0
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
// this program.  If not, see <https://opensource.org/license/gpl-3-0>.
///
/// Authors: Bo Zhang (Lutra-Fs), Graham Williams

library;

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

import 'package:rattle/constants/temp_dir.dart';
import 'package:rattle/providers/dataset.dart';
import 'package:rattle/providers/script.dart';
import 'package:rattle/providers/settings.dart';
import 'package:rattle/utils/debug_text.dart';

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
  void initState() {
    super.initState();

    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // Update "Session Control" state.

    ref.read(askOnExitProvider.notifier).state =
        prefs.getBool('askOnExit') ?? true;
  }

  @override
  Widget build(BuildContext context) {
    // Check the askOnExitProvider state.

    final askOnExit = ref.watch(askOnExitProvider);

    if (!askOnExit) {
      // If askOnExitProvider is OFF, close the app directly.

      _closeApp();

      return const SizedBox.shrink();
    }

    // If askOnExitProvider is ON, show the confirmation dialog.

    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.close, size: 24, color: Colors.blue),
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
        TextButton(onPressed: _closeApp, child: const Text('Close')),
      ],
    );
  }

  void _closeApp() async {
    // capture navigator before async gaps to avoid BuildContext across async gaps

    final navigator = Navigator.of(context);

    // save window size before closing if the setting is enabled
    final rememberSize = ref.read(rememberWindowSizeProvider);
    if (rememberSize) {
      try {
        final size = await WindowManager.instance.getSize();
        final prefs = await SharedPreferences.getInstance();
        await prefs.setDouble('windowWidth', size.width);
        await prefs.setDouble('windowHeight', size.height);

        // update providers to reflect saved values
        ref.read(windowWidthProvider.notifier).state = size.width;
        ref.read(windowHeightProvider.notifier).state = size.height;
      } catch (e) {
        debugPrint('Error saving window size: $e');
      }
    }

    navigator.pop();
    cleanUpTempDirs();
    WindowManager.instance.setPreventClose(false);
    WindowManager.instance.close();
  }

  Future<void> _showFileNameDialog(BuildContext context) async {
    // TODO 20250321 gjw DUPLICATED CODE WITH `tabs/script/save_button.dart`
    final String dsname = ref.read(dsnameProvider);
    // Format the date now as yyyymmdd to include this in the daved script
    // filename. (gjw 20250321)
    final now = DateTime.now();
    String yyyymmdd = "${now.year.toString().padLeft(4, '0')}"
        "${(now.month).toString().padLeft(2, '0')}"
        "${(now.day).toString().padLeft(2, '0')}";

    final outputPath = await FilePicker.platform.saveFile(
      dialogTitle: 'Provide a .R filename to save the R script to',
      fileName: 'script_$yyyymmdd${dsname.isNotEmpty ? "_" : ""}$dsname.R',
      type: FileType.custom,
      allowedExtensions: ['R'],
    );

    if (!mounted) return;

    if (outputPath != null) {
      _saveScript(outputPath);
    } else {
      setState(() {
        _title = 'Error';
        _content = wordWrap('''

          No file selected.  You can still close the app or try saving the
          script again.

            ''');
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
