/// A text widget showing the current rattle state.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
// Licensed under the GNU General Public License, Version 3 (the "License");
///
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

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/app.dart';
import 'package:rattle/provider/path.dart';
import 'package:rattle/provider/status.dart';
import 'package:rattle/provider/normalise.dart';
import 'package:rattle/provider/partition.dart';
//import 'package:rattle/utils/count_lines.dart';
//import 'package:rattle/utils/truncate.dart';
//import 'package:rattle/models/rattle_model.dart';

class RattleStateText extends ConsumerWidget {
  const RattleStateText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialise the state variables used here.

    String status = ref.read(statusProvider);
    String path = ref.read(pathProvider);
    bool partition = ref.read(partitionProvider);
    bool normalise = ref.read(normaliseProvider);

    return SingleChildScrollView(
      child: Builder(
        builder: (BuildContext context) {
//          return Consumer<RattleState>(
          // As a [Consumer] of the [RattleState] recording the app's state we can
          // access the status message as it gets updated, so that the status bar
          // remains up to date.

//            builder: (context, rattle, child) {
          // The builder takes a context, a RattleState, and the child. It is the
          // `rattle` that contains the state that we can access here.

          return SelectableText(
            "STATUS: $status\n\n"
            "SCRIPT: \${countLines(rattle.script)} lines\n\n"
            "STDOUT: \${countLines(rattle.stdout)} lines\n\n"
            "STDERR: \${countLines(rattle.stderr)} lines\n\n"
            "PATH: $path\n\n"
            "NORMALISE: $normalise\n\n"
            "PARTITION: $partition\n\n"
            "VARS: \${truncate(rattle.vars.toString())} \n\n"
            "TARGET: \${rattle.target} \n\n"
            "RISK: \${rattle.risk} \n\n"
            "IDENTIFIERS: \${rattle.identifiers} \n\n"
            "IGNORE: \${rattle.ignore} \n\n"
            "MODEL: \${rattle.model}\n\n",
            // rExtractGlimpse(rattle.stdout),
            style: monoSmallTextStyle,
          );
//            },
//          );
        },
      ),
    );
  }
}
