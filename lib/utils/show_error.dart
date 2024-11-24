/// A dialog to show an error message with a customizable OK button action.
//
// Time-stamp: <Sunday 2024-07-21 17:25:02 +1000 Graham Williams>
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

import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:markdown_tooltip/markdown_tooltip.dart';

void showError({
  required BuildContext context,
  required String title,
  required String content,
  required VoidCallback onOkPressed,
}) {
  // Set up the Exit button
  Widget ExitButton = TextButton(
    child: const Text('Exit'),
    onPressed: () {
      // Execute the custom behavior
      onOkPressed();
    },
  );

  // Set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Row(
      children: [
        const Icon(Icons.warning, color: Colors.red),
        const SizedBox(width: 20),
        Text(title),
      ],
    ),
    content: MarkdownBody(
      data: wordWrap(content),
      selectable: true,
      softLineBreak: true,
    ),
    actions: [
      ExitButton,
    ],
  );

  // Show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
