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

import 'package:rattle/features/dataset/popup.dart';
import 'package:rattle/providers/dataset_loaded.dart';
import 'package:rattle/utils/reset.dart';
import 'package:rattle/utils/word_wrap.dart';
import 'package:rattle/widgets/delayed_tooltip.dart' show DelayedTooltip;

class DatasetButton extends ConsumerWidget {
  const DatasetButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        if (ref.read(datasetLoaded)) {
          showAlertPopup(context, ref, true);
        } else {
          _showOptionPopup(context, ref);
        }
      },
      child: const DelayedTooltip(
        message: '''

        Tap here to view a popup with the option to load data from a CSV or TXT
        file, or from an R package's dataset, or to load the demo dataset from
        rattle::weather.

        ''',
        child: Text('Dataset'),
      ),
    );
  }
}

void showAlertPopup(
  BuildContext context,
  WidgetRef ref,
  bool loadNewDataset,
) {
  // Show Alert Window and then reset the app after confirmation.
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 20),
            Text('Warning'),
          ],
        ),
        content: Text(
          wordWrap('''

            Please note that currently loading a new dataset is not fully
            operational. If you load a new dataset it will reset the app but the
            reset is not yet complete. It is best to exit the app and restart
            it. Otherwise, are you sure you would like to reset?

            '''),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Yes'),
            onPressed: () async {
              // 20240817 gjw Note the reset before showOptionPopup because the
              // other way around casues a bug? First set load to true and then
              // reset it to false but the dataset actually is loaded as a
              // consequence the previous result won't be reset because load
              // indicates no dataset has been loaded and the app is fresh.
              await reset(context, ref);
              if (context.mounted) Navigator.of(context).pop();

              if (loadNewDataset) {
                if (context.mounted) _showOptionPopup(context, ref);
              }
            },
          ),
        ],
      );
    },
  );
}

void _showOptionPopup(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const DatasetPopup();
    },
  );
}
