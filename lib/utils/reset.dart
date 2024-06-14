// Reset the app
//
// Time-stamp: <Thursday 2024-06-06 05:58:50 +1000 Graham Williams>
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
/// Authors: Yixiang Yin

library;

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rattle/providers/dataset_loaded.dart';
import 'package:rattle/providers/path.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/providers/terminal.dart';
import 'package:rattle/providers/wordcloud/build.dart';
import 'package:rattle/providers/wordcloud/checkbox.dart';
import 'package:rattle/providers/wordcloud/maxword.dart';
import 'package:rattle/providers/wordcloud/minfreq.dart';
import 'package:rattle/providers/wordcloud/punctuation.dart';
import 'package:rattle/providers/wordcloud/stem.dart';
import 'package:rattle/providers/wordcloud/stopword.dart';
import 'package:rattle/r/start.dart';
import 'package:xterm/xterm.dart';

void reset(BuildContext context, WidgetRef ref) {
  debugPrint('RESET');
  // reset the app
  // ideally if the app renders based on states stored in providers, we just need to reset each provider to the starting value
  // MODEL TAB
  // reset wordcloud tab
  ref.read(wordCloudBuildProvider.notifier).state = '';

  ref.read(checkboxProvider.notifier).state = false;
  ref.read(punctuationProvider.notifier).state = false;
  ref.read(stemProvider.notifier).state = false;
  ref.read(stopwordProvider.notifier).state = false;
  ref.read(maxWordProvider.notifier).state = '';
  ref.read(minFreqProvider.notifier).state = '';
  // reset the stdoutProvider, this reset the tree tab, forest tab as they depend on it
  ref.read(stdoutProvider.notifier).state = '';
  // CONSOLE TAB
  ref.read(terminalProvider.notifier).state = Terminal();
  rStart(ref);
  // DATASET TAB
  ref.read(pathProvider.notifier).state = '';
  debugPrint('DATASET UNLOADED');
  ref.read(datasetLoaded.notifier).state = false;
}
