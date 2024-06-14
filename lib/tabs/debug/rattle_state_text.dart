/// A text widget showing the current rattle state.
///
/// Time-stamp: <Sunday 2024-06-02 14:57:36 +1000 Graham Williams>
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

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/app.dart';
import 'package:rattle/providers/model.dart';
import 'package:rattle/providers/cleanse.dart';
import 'package:rattle/providers/normalise.dart';
import 'package:rattle/providers/partition.dart';
import 'package:rattle/providers/path.dart';
import 'package:rattle/providers/script.dart';
import 'package:rattle/providers/status.dart';
import 'package:rattle/providers/stderr.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/providers/target.dart';
import 'package:rattle/providers/vars.dart';
import 'package:rattle/utils/count_lines.dart';
import 'package:rattle/utils/truncate.dart';

class RattleStateText extends ConsumerWidget {
  const RattleStateText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialise the state variables used here.

    String path = ref.watch(pathProvider);
    String status = ref.watch(statusProvider);
    String script = ref.watch(scriptProvider);
    String stderr = ref.watch(stderrProvider);
    String stdout = ref.watch(stdoutProvider);
    String model = ref.watch(modelProvider);
    String target = ref.watch(targetProvider);
    List<String> vars = ref.watch(varsProvider);
    bool cleanse = ref.watch(cleanseProvider);
    bool normalise = ref.watch(normaliseProvider);
    bool partition = ref.watch(partitionProvider);

    return SingleChildScrollView(
      child: Builder(
        builder: (BuildContext context) {
          return SelectableText(
            'STATUS:      $status\n'
            'SCRIPT:      ${countLines(script)} lines\n'
            'STDOUT:      ${countLines(stdout)} lines\n'
            'STDERR:      ${countLines(stderr)} lines\n'
            'PATH:        $path\n'
            'CLEANSE:     $cleanse\n'
            'NORMALISE:   $normalise\n'
            'PARTITION:   $partition\n'
            'VARS:        ${truncate(vars.toString())}\n'
            'TARGET:      $target\n'
            'RISK:        \$risk \n'
            'IDENTIFIERS: \$identifiers \n'
            'IGNORE:      \$ignore\n'
            'MODEL:       $model\n',
            style: monoSmallTextStyle,
          );
        },
      ),
    );
  }
}
