// Reset the app
//
// Time-stamp: <Sunday 2024-09-08 12:06:39 +1000 Graham Williams>
//
/// Copyright (C) 2024, Togaware Pty Ltd
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
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
/// Authors: Yixiang Yin, Graham Williams

library;

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO 20240618 gjw DO WE NEED ALL OF `app.dart`? I THINK IT IS JUST
// `rattleHomeKey` CAN THAT GO INTO A CONSTANTS FILE INSTEAD WHIC WE IMPORT HERE
// AND INTO app.dart?

import 'package:rattle/app.dart';
import 'package:rattle/constants/temp_dir.dart';
import 'package:rattle/providers/dataset_loaded.dart';
import 'package:rattle/providers/model.dart';
import 'package:rattle/providers/path.dart';
import 'package:rattle/providers/script.dart';
import 'package:rattle/providers/vars/roles.dart';
import 'package:rattle/providers/vars/types.dart';
import 'package:rattle/providers/status.dart';
import 'package:rattle/providers/stderr.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/providers/target.dart';
import 'package:rattle/providers/terminal.dart';
import 'package:rattle/providers/wordcloud/build.dart';
import 'package:rattle/providers/wordcloud/checkbox.dart';
import 'package:rattle/providers/wordcloud/maxword.dart';
import 'package:rattle/providers/wordcloud/minfreq.dart';
import 'package:rattle/providers/wordcloud/punctuation.dart';
import 'package:rattle/providers/wordcloud/stem.dart';
import 'package:rattle/providers/wordcloud/stopword.dart';
import 'package:rattle/r/start.dart';
import 'package:rattle/utils/debug_text.dart';

Future<void> reset(BuildContext context, WidgetRef ref) async {
  debugText('  RESET');

  // Clear all .svg files in the tempDir.
  final tempDirectory = Directory(tempDir);
  if (await tempDirectory.exists()) {
    final svgFiles = tempDirectory
        .listSync()
        .where((file) => file is File && file.path.endsWith('.svg'));

    for (var file in svgFiles) {
      try {
        await File(file.path).delete();
        debugPrint('Deleted: ${file.path}');
      } catch (e) {
        debugPrint('Error deleting file ${file.path}: $e');
      }
    }
  }

  // Reset the app.
  //
  // Ideally if the app renders based on states stored in providers, we just
  // need to reset each provider to the starting value.

  // GENERAL PROVIDERS

  ref.invalidate(statusProvider);
  ref.invalidate(stderrProvider);
  ref.invalidate(stdoutProvider);

  // DATASET TAB

  // Note that we do not reset the toggles - they need to remain as they are.

  ref.invalidate(datasetLoaded);
  ref.invalidate(pathProvider);
  ref.invalidate(rolesProvider);
  ref.invalidate(typesProvider);
  ref.invalidate(scriptProvider);
  ref.invalidate(typesProvider);

  // MODEL TAB

  ref.invalidate(modelProvider);
  ref.invalidate(targetProvider);

  // Reset WORDCLOUD tab.

  ref.invalidate(wordCloudBuildProvider);
  ref.invalidate(checkboxProvider);
  ref.invalidate(punctuationProvider);
  ref.invalidate(stemProvider);
  ref.invalidate(stopwordProvider);
  ref.invalidate(maxWordProvider);
  ref.invalidate(minFreqProvider);

  // Reset the stdoutProvider, this resets the tree tab and the forest tab as
  // they depend on it

  ref.invalidate(stdoutProvider);

  // CONSOLE TAB

  ref.invalidate(terminalProvider);
  if (context.mounted) rStart(context, ref);

  // TODO yyx 20240618 might need to reset sub-tabs to the first one.
  // RESET TAB INDEX (including sub-tabs)

  rattleHomeKey.currentState?.goToDatasetTab();
}
