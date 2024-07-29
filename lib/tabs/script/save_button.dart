/// A button to save the script to file.
///
/// Time-stamp: <Monday 2024-07-29 09:19:06 +1000 Graham Williams>
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
/// Authors: Graham Williams
library;

import 'dart:io' show File;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/providers/script.dart';

class ScriptSaveButton extends ConsumerWidget {
  const ScriptSaveButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      child: const Text('Export'),
      onPressed: () {
        debugPrint("SAVE BUTTON EXPORT: 'script.R'");
        String script = ref.read(scriptProvider);
        // Remove the svg/dev.off lines.
        List<String> lines = script.split('\n');
        lines = lines.where((line) => !line.trim().startsWith('svg')).toList();
        lines =
            lines.where((line) => !line.trim().startsWith('dev.off')).toList();
        script = lines.join('\n');
        File('script.R').writeAsString(script);
      },
    );
  }
}
