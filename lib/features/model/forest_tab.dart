/// Tab to display the forest model
//
// Time-stamp: <Thursday 2024-06-06 05:58:50 +1000 Graham Williams>
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

import 'package:rattle/constants/app.dart';
import 'package:rattle/provider/stdout.dart';
import 'package:rattle/r/extract_forest.dart';
import 'package:rattle/utils/add_build_button.dart';

class ForestTab extends ConsumerWidget {
  final Widget buildButton;
  const ForestTab({super.key, required this.buildButton});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String stdout = ref.watch(stdoutProvider);
    Widget content = Expanded(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 10),
        child: SingleChildScrollView(
          child: SelectableText(
            rExtractForest(stdout),
            style: monoTextStyle,
          ),
        ),
      ),
    );

    return addBuildButton(content, buildButton);
  }
}
