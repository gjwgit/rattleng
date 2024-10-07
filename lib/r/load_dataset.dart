/// Load a dataset through the appropriate R script.
///
/// Time-stamp: <Monday 2024-10-07 18:54:45 +1100 Graham Williams>
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
/// Authors: Graham Williams, Yixiang Yin

library;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/app.dart';
import 'package:rattle/providers/path.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/utils/debug_text.dart';

/// Load the specified dataset using the appropriate R script.
///
/// The R script is expected to load the data into the template variable `ds`,
/// and define `dsname` as the dataset name and `vnames` as a named list of the
/// original variable names having as values the current variable names, being
/// different in the case where the dataset variables have been normalised,
/// which is the default.

Future<void> rLoadDataset(BuildContext context, WidgetRef ref) async {
  // On loading a dataset we run the main R script to initialise a new session.

  // Get the path to the dataset from the provider to identify either a filename
  // or an R package dataset.

  String path = ref.read(pathProvider);

  // TODO 20231018 gjw IF A DATASET HAS ALREADY BEEN LOADED AND NOT YET
  // PROCESSED (dataset_template.R) THEN PROCESS ELSE ASK IF WE CAN OVERWRITE IT
  // AND IF SO DO SO OTHERWISE DO NOTHING.

  debugText('R LOAD', path);

  // Ensure there is no extraneous white space.

  path = path.trim();

  // R Scripts.

  String ss = 'session_setup';
  String dw = 'dataset_load_weather';
  String dc = 'dataset_load_csv';
  String dx = 'dataset_load_txt';
  String dt = 'dataset_template';

  if (path == '' || path == weatherDemoFile) {
    // 20241007 gjw If no path is specified then we load the sample dataset from
    // Rattle. At this time through the GUI we do not have an empty path nor are
    // we using the rattle::weather dataset which is rather dated. So this
    // option is not currently utilised.

    if (context.mounted) await rSource(context, ref, [ss, dw, dt]);
  } else if (path.endsWith('.csv')) {
    // 20241007 gjw For a CSV file specified we will load that CSV file into the
    // R process.

    if (context.mounted) await rSource(context, ref, [ss, dc, dt]);
  } else if (path.endsWith('.txt')) {
    // 20241007 gjw We can also load a text file for the word cloud
    // functionality as a stop gap toward implementing more complete text mining
    // and language capabilities.

    if (context.mounted) await rSource(context, ref, [ss, dx]);
  } else {
    // 20241007 gjw Through the GUI we don't expect to be able to reach here.

    debugPrint('LOAD_DATASET: PATH NOT RECOGNISED -> ABORT: $path.');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('PATH NOT RECOGNISED'),
        content: const Text('Unable to load dataset'),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );

    return;
  }

  debugText('R LOADED', path);

  return;
}
