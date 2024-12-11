/// A button to choose a dataset (from file/package/demo).
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

library;

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';

import 'package:rattle/features/dataset/popup.dart';
import 'package:rattle/providers/dataset_loaded.dart';
import 'package:rattle/providers/reset.dart';
import 'package:rattle/utils/show_dataset_alert_dialog.dart';

class DatasetButton extends ConsumerWidget {
  const DatasetButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        // Set isResetProvider to true to ensure MODEL/TRANSFORM/EXPLORE
        // tab reverts to the overview page

        ref.read(isResetProvider.notifier).state = true;

        if (ref.read(datasetLoaded)) {
          showDatasetAlertDialog(context, ref, true);
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const DatasetPopup();
            },
          );
        }
      },
      child: const MarkdownTooltip(
        message: '''

        **Dataset:** Tap here to choose a dataset to load.  A popup provides
        options to load data from a **csv** or **txt** file, or from an R
        package dataset. **Demo** datasets are also available and provide a
        quick opportunity to explore Rattle. Datasets include one year of
        Canberra *weather* for predictive **Model** for rain tomorrow, an
        illustrative financial *audit* dataset to **Model** the auit outcome, a
        *movie* dataet for basket analysis through **Association** rules, and a
        text file *sherlock* for generating a **Word Cloud**.

        ''',
        child: Text('Dataset'),
      ),
    );
  }
}
