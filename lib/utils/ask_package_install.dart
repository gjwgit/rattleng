/// Ask whether to install a missing package.
//
// Time-stamp: <Wednesday 2024-07-17 15:01:20 +1000 Graham Williams>
//
/// Copyright (C) 2024, Togaware Pty Ltd
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
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
/// Authors: Graham WIlliams

library;

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'package:flutter/material.dart';

Future<bool> askPackageInstall(BuildContext context, String message) async {
  // Set up the buttons
  Widget noButton = ElevatedButton(
    child: const Text('No'),
    onPressed: () {
      Navigator.of(context).pop(false); // Close the dialog and return false
    },
  );

  Widget yesButton = ElevatedButton(
    child: const Text('Yes'),
    onPressed: () {
      Navigator.of(context).pop(true); // Close the dialog and return true
    },
  );

  // Set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text('Do you want to install "$message"?'),
    content: Text('The R package "$message" is not installed.\n'
        'I can attempt to install it now through your R Console.\n'
        'Shall I proceed?'),
    actions: [
      noButton,
      yesButton,
    ],
  );

  // Show the dialog
  final result = await showDialog<bool?>(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );

  return result ?? false; // Return false if the dialog is dismissed
}
