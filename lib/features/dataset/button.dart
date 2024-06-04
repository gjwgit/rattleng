/// A button to choose a dataset (from file or a package).
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

import 'package:flutter/material.dart';

import 'package:rattle/features/dataset/popup.dart';
import 'package:rattle/widgets/delayed_tooltip.dart' show DelayedTooltip;

bool LOADED = true;

class DatasetButton extends StatelessWidget {
  const DatasetButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // TODO yyx when user clicking the dataset button
        // first show the window asking if you really want to load a new one and that will clear everything if a dataset has been loaded
        // The pop up window has yes or no buttion.
        // if Yes, clear every state in the app and showPopup
        // if No, dismiss the popup window
        if (LOADED) {
          _showConfirmPopup(context);
        }
      },
      child: const DelayedTooltip(
        message: 'Click here to have the option to load the data from a file,\n'
            'including CSV files, or from an R pacakge, or to load \n'
            'the demo dataset, rattle::weather.',
        child: Text('Dataset'),
      ),
    );
  }

  void _showConfirmPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning'),
          content: const Text(
            'If you load a new dataset, the old one will be removed.\nAre you sure?',
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
              onPressed: () {
                Navigator.of(context).pop();
                _showPopup(context);
                // TODO yyx clear every state
              },
            ),
          ],
        );
      },
    );
  }

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const DatasetPopup();
      },
    );
  }
}
