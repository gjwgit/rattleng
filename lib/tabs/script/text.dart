/// An R script text widget for the SCRIPT tab page.
///
/// Copyright (C) 2023-2025, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Monday 2024-12-02 05:33:57 +1100 Graham Williams>
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
/// Authors: Graham Williams

library;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/style.dart';
import 'package:rattle/constants/keys.dart';
import 'package:rattle/providers/script.dart';
import 'package:rattle/tabs/script/save_button.dart';

/// Create a script text viewer that can scroll the text of the script widget.
///
/// The contents is intialised from the main.R script asset.

class ScriptText extends ConsumerWidget {
  const ScriptText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Build the widget.

    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          // Main content with scrollable text
          SingleChildScrollView(
            child: Builder(
              builder: (BuildContext context) {
                final script = ref.watch(scriptProvider);

                return SelectableText(
                  script,
                  key: scriptTextKey,
                  style: monoSmallTextStyle,
                );
              },
            ),
          ),
          // ScriptSaveButton at the top-right corner.

          Positioned(
            top: 8.0,
            right: 8.0,
            child: const ScriptSaveButton(),
          ),
        ],
      ),
    );
  }
}
