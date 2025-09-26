/// An alert popup warning about the new dataset and reset.
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: https://opensource.org/license/gpl-3-0
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
// this program.  If not, see <https://opensource.org/license/gpl-3-0>.
///
/// Authors: Graham Williams

library;

import 'package:flutter/material.dart';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';

import 'package:rattle/features/dataset/popup.dart';
import 'package:rattle/utils/reset.dart';

void showDatasetAlertDialog(
  BuildContext context,
  WidgetRef ref,
  bool loadNewDataset, {
  String title = 'Load a Dataset',
}) {
  // Show Alert Window and then reset the app after confirmation.
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 20),
            Text(title),
          ],
        ),
        content: MarkdownBody(
          data: wordWrap('''

            **Loading** a new dataset or **Reseting** the app will clear out all
            of the current data and the captured R script. You will lose any
            work already completed. You may like to consider saving your R
            script from the Script tab before continuing so you can replicate
            your activity in Rattle later on in R itself.  Are you sure you
            would like to **continue**?

            '''),
          selectable: true,
          softLineBreak: true,
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
                if (context.mounted) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const DatasetPopup();
                    },
                  );
                }
              }
            },
          ),
        ],
      );
    },
  );
}
