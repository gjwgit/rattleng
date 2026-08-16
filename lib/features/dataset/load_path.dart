/// Load a dataset from a file path and update the app state to suit.
///
/// Time-stamp: "Saturday 2026-08-15 06:56:25 +1000 Graham Williams"
///
/// Copyright (C) 2026, Togaware Pty Ltd.
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
/// Authors: Graham Williams

library;

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/status.dart';
import 'package:rattle/providers/dataset.dart';
import 'package:rattle/providers/dataset_loaded.dart';
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/providers/path.dart';
import 'package:rattle/r/load_dataset.dart';
import 'package:rattle/utils/set_status.dart';

void datasetLoadedUpdate(WidgetRef ref) {
  ref.read(datasetLoaded.notifier).state = true;
}

/// Turn [path], as supplied on the command line, into a path R can use.
///
/// A relative path is resolved against the current working directory of the
/// shell that started Rattle, since the R process has its own notion of the
/// working directory. Backslashes are mapped to forward slashes because the
/// path is substituted into an R string, as in `read_csv("<FILENAME>")`, where
/// the Windows `C:\Users\...` form is not accepted by R. (gjw 20260815)

String resolveDatasetPath(String path) =>
    File(path).absolute.path.replaceAll(r'\', '/');

/// Load the dataset found at [path] and update the app state to suit.
///
/// This is the common tail of loading a dataset from a local file, whether the
/// file was chosen through the DATASET popup or was named on the command
/// line. On return the dataset is loaded into the R process, the variable roles
/// are ready to be reviewed, and the DATASET tab shows the ROLES page.

Future<void> loadDatasetPath(
  BuildContext context,
  WidgetRef ref,
  String path,
) async {
  ref.read(pathProvider.notifier).state = path;

  if (context.mounted) await rLoadDataset(context, ref);

  setStatus(ref, statusChooseVariableRoles);

  datasetLoadedUpdate(ref);

  // Save the dataset name in lowercase to the dsnameProvider from the path.

  ref.read(dsnameProvider.notifier).state =
      path.split(RegExp(r'[/\\]')).last.split('.').first.toLowerCase();

  // Access the PageController via Riverpod and move to the second page, being
  // the ROLES page. The [hasClients] guard is for the command line load, which
  // can complete before the PageView of `features/dataset/display.dart` has
  // been laid out, in which case there is no page to animate. (gjw 20260815)

  final PageController controller = ref.read(pageControllerProvider);

  if (controller.hasClients) {
    await controller.animateToPage(
      // Index of the second page.
      1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
