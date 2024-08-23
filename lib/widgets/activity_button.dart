/// An ElevatedButton implementing Activity initiation for Rattle.
//
// Time-stamp: <Tuesday 2024-08-20 16:50:04 +1000 Graham Williams>
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
/// Authors: Graham Williams, Yixiang Yin

library;

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/providers/path.dart';
import 'package:rattle/utils/debug_text.dart';
import 'package:rattle/utils/show_ok.dart';

class ActivityButton extends ConsumerWidget {
  final VoidCallback onPressed;
  final Widget child;

  const ActivityButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugText('  BUILD', 'ActivityButton');

    return ElevatedButton(
      onPressed: () {
        String path = ref.read(pathProvider);

        if (path.isEmpty) {
          showOk(
            context: context,
            title: 'No Dataset Loaded',
            content: '''

            Please choose a dataset to load from the **Dataset** tab. There is
            not much we can do until we have loaded a dataset.

            ''',
          );
        } else {
          onPressed();
        }
      },
      child: child,
    );
  }
}
