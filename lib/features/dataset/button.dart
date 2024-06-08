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

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/features/dataset/popup.dart';
import 'package:rattle/provider/dataset_loaded.dart';
import 'package:rattle/utils/reset.dart';
import 'package:rattle/widgets/delayed_tooltip.dart' show DelayedTooltip;

class DatasetButton extends ConsumerWidget {
  const DatasetButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        // WHEN USER CLICKS THE DATASET BUTTON
        // FIRST SHOW THE WINDOW ASKING IF YOU REALLY WANT TO LOAD A NEW ONE AND THAT WILL CLEAR EVERYTHING IF A DATASET HAS BEEN LOADED
        // THE POP UP WINDOW HAS YES OR NO BUTTION.
        // IF YES, CLEAR EVERY STATE IN THE APP AND SHOW POPUP WINDOW
        // IF NO, DISMISS THE POPUP WINDOW
        if (ref.read(datasetLoaded)) {
          _showAlertPopup(context, ref);
        } else {
          _showOptionPopup(context, ref);
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

  void _showAlertPopup(BuildContext context, WidgetRef ref) {
    // Show Alert Window to Reset, Reset after confirmation
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning'),
          content: const Text(
            'If you load a new dataset, it will reset the app.\nAre you sure?',
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
                // RESET BEFORE SHOWOPTIONPOPUP BECAUSE THE OTHER WAY AROUND CASUES BUG:
                // FIRST SET LOAD TO TRUE AND THEN RESET IT TO FALSE
                // BUT THE DATASET ACTUALLY IS LOADED
                // AS A CONSEQUENCE THE PREVIOUS RESULT WON'T BE RESET
                // BECAUSE LOAD INDICATES NO DATASET HAS BEEN LOADED AND THE APP IS FRESH
                reset(context, ref);
                _showOptionPopup(context, ref);
              },
            ),
          ],
        );
      },
    );
  }

  void _showOptionPopup(BuildContext context, WidgetRef ref) {
    // TODO yyx 20240607 if we cancel we are not loaded.
    // perhaps put this after each option in the DATASETPOPUP except the cancel button.
    debugPrint('DATASET LOADED');
    ref.read(datasetLoaded.notifier).state = true;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const DatasetPopup();
      },
    );
  }
}
