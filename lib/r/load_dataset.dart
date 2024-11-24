/// Load a dataset through the appropriate R script.
///
/// Time-stamp: <Saturday 2024-11-23 16:46:54 +1100 Graham Williams>
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
import 'package:rattle/providers/datatype.dart';
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
  String dp = 'dataset_prep'; // Dataset cleaning and prepartion pre-template.

  if (path == '' || path == weatherDemoFile) {
    // 20241007 gjw If no path is specified then we load the sample dataset from
    // Rattle. At this time through the GUI we do not have an empty path nor are
    // we using the rattle::weather dataset which is rather dated. So this
    // option is not currently utilised.

    if (context.mounted) await rSource(context, ref, [ss, dw, dp]);
  } else if (path.endsWith('.csv')) {
    // 20241007 gjw We will load a CSV file into the R process. Note that we do
    // not yet run the DATA TEMPLATE as we need to first set up the ROLES. The
    // dataset template is run in `home.dart` on leaving the DATASET tab.

    if (context.mounted) await rSource(context, ref, [ss, dc, dp]);

    ref.read(datatypeProvider.notifier).state = 'table';
  } else if (path.endsWith('.txt')) {
    // 20241007 gjw We can also load a text file for the word cloud
    // functionality as a stop gap toward implementing more complete text mining
    // and language capabilities.

    if (context.mounted) await rSource(context, ref, [ss, dx]);

    ref.read(datatypeProvider.notifier).state = 'text';
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
