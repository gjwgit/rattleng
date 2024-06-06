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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';

import 'package:rattle/features/dataset/popup.dart';
import 'package:rattle/provider/stdout.dart';
import 'package:rattle/provider/terminal.dart';
import 'package:rattle/r/start.dart';
import 'package:rattle/widgets/delayed_tooltip.dart' show DelayedTooltip;
import 'package:xterm/xterm.dart';

bool LOADED = true;

class DatasetButton extends ConsumerWidget {
  const DatasetButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        // TODO yyx when user clicking the dataset button
        // first show the window asking if you really want to load a new one and that will clear everything if a dataset has been loaded
        // The pop up window has yes or no buttion.
        // if Yes, clear every state in the app and showPopup
        // if No, dismiss the popup window
        if (LOADED) {
          _showConfirmPopup(context, ref);
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

  void _showConfirmPopup(BuildContext context, WidgetRef ref) {
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
                _showPopup(context);
                // TODO yyx clear every state
                reset(context, ref);
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
  void reset(BuildContext context, WidgetRef ref) {
    // clear the state of the app
    // ideally if the app renders based on states stored in providers, we just reset each provider to the start
    // TODO yyx 20240605 clear wordcloud tab; perhaps need to restructure wordcloud
    // load the dataset, build wordcloud, load a new one, we shouldn't see the previous wordcloud
    // reset the stdoutProvider, this reset the tree tab, forest tab as they depend on it
    ref.read(stdoutProvider.notifier).state = '';
    // reset console
    ref.read(terminalProvider.notifier).state = Terminal();
    rStart(ref);
  }
}
