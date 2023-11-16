/// Dataset tab for home page.
///
/// Time-stamp: <Saturday 2023-10-28 08:07:23 +1100 Graham Williams>
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
//
// Licensed under the GNU General Public License, Version 3 (the "License");
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

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/app.dart';
import 'package:rattle/constants/keys.dart';
import 'package:rattle/features/dataset/chooser.dart';
import 'package:rattle/provider/path.dart';
import 'package:rattle/provider/stdout.dart';
import 'package:rattle/r/extract_glimpse.dart';
import 'package:rattle/widgets/markdown_file.dart';
import 'package:rattle/features/dataset/dataset_table.dart';

// TODO 20230916 gjw DOES THIS NEED TO BE STATEFUL?

class DatasetTab extends ConsumerStatefulWidget {
  const DatasetTab({Key? key}) : super(key: key);

  @override
  ConsumerState<DatasetTab> createState() => _DatasetTabState();
}

class _DatasetTabState extends ConsumerState<DatasetTab> {
  @override
  Widget build(BuildContext context) {
    String path = ref.watch(pathProvider);
    String stdout = ref.watch(stdoutProvider);

    return Scaffold(
      body: Column(
        children: [
          const DatasetChooser(),

          // A text view that takes up the remaining space and displays the
          // Rattle welcome and getting started message. This will be
          // overwritten once a dataset is loaded.

          Visibility(
            visible: path == "",
            child: Expanded(
              child: Center(
                key: welcomeTextKey,
                child: sunkenMarkdownFileBuilder(welcomeMsgFile),
              ),
            ),
          ),
          Visibility(
            visible: path != "",
            child: Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 10),
                child: DataTableWidget(["Col 1", "Col 2", "Col 3"]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
