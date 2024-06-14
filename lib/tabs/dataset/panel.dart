/// Widget to display the Rattle introduction or data view.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Friday 2024-06-14 14:28:13 +1000 Graham Williams>
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

import 'package:rattle/constants/app.dart';
import 'package:rattle/constants/sunken_box_decoration.dart';
import 'package:rattle/constants/keys.dart';
import 'package:rattle/providers/path.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/r/extract_glimpse.dart';
import 'package:rattle/widgets/show_markdown_file.dart';

/// The dataset panel displays the RattleNG welcome or a data summary.

class DatasetPanel extends ConsumerStatefulWidget {
  const DatasetPanel({super.key});

  @override
  ConsumerState<DatasetPanel> createState() => _DatasetPanelState();
}

class _DatasetPanelState extends ConsumerState<DatasetPanel> {
  @override
  Widget build(BuildContext context) {
    String path = ref.watch(pathProvider);
    String stdout = ref.watch(stdoutProvider);

    return path == ''
        ? showMarkdownFile(welcomeMsgFile)
        : Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.only(left: 10),
              child: SelectableText(
                rExtractGlimpse(stdout),
                key: datasetGlimpseKey,
                style: monoTextStyle,
              ),
            ),
          );
  }
}
