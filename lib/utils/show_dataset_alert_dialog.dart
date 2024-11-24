/// An alert popup warning about the new dataset and reset.
///
/// Copyright (C) 2024, Togaware Pty Ltd.
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

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';

import 'package:rattle/features/dataset/popup.dart';
import 'package:rattle/utils/reset.dart';

void showDatasetAlertDialog(
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

            Please note that if you load a new dataset it will reset the app by
            clearing out all of the current data. You will lose any work already
            completed. Consider saving your R script from the Script tab before
            continuing.  Otherwise, are you sure you would like to reset?

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
                if (context.mounted)
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const DatasetPopup();
                    },
                  );
              }
            },
          ),
        ],
      );
    },
  );
}
