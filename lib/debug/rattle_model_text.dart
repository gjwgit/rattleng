/// A text widget showing the rattle model (current rattle state).
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

import 'package:provider/provider.dart';

import 'package:rattle/constants/app.dart';
import 'package:rattle/helpers/count_lines.dart';
import 'package:rattle/helpers/truncate.dart';
import 'package:rattle/models/dataset.dart';
import 'package:rattle/models/rattle.dart';

class DatasetModelText extends StatelessWidget {
  const DatasetModelText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Builder(
        builder: (BuildContext context) {
          return Consumer<RattleModel>(
            // As a [Consumer] of the [DatasetModel] recording the app's state we can
            // access the status message as it gets updated, so that the status bar
            // remains up to date.

            builder: (context, rattle, child) {
              // The builder takes a context, a DatasetModel, and the child. It is the
              // `rattle` that contains the state that we can access here.

              return Consumer<DatasetModel>(
                builder: (context, dataset, child) {
                  return SelectableText(
                    "STATUS: ${rattle.status}\n\n"
                    "SCRIPT: ${countLines(rattle.script)} lines\n\n"
                    "STDOUT: ${countLines(rattle.stdout)} lines\n\n"
                    "STDERR: ${countLines(rattle.stderr)} lines\n\n"
                    "PATH: ${dataset.path}\n\n"
                    "NORMALISE: ${dataset.normalise}\n\n"
                    "PARTITION: ${dataset.partition}\n\n"
                    "VARS: ${truncate(dataset.vars.toString())} \n\n"
                    "TARGET: ${dataset.target} \n\n"
                    "RISK: ${dataset.risk} \n\n"
                    "IDENTIFIERS: ${dataset.identifiers} \n\n"
                    "IGNORE: ${dataset.ignore} \n\n"
                    "MODEL: ${rattle.model}\n\n",
                    style: monoSmallTextStyle,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
