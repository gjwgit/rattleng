/// First and Dataset page for the first Data tab.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
//
// Time-stamp: <Sunday 2023-09-10 18:18:22 +1000 Graham Williams>
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

import 'package:rattle/constants/app.dart';
import 'package:rattle/widgets/dataset_chooser.dart';
import 'package:rattle/widgets/markdown_file.dart';

class DataTabPage extends StatefulWidget {
  const DataTabPage({Key? key}) : super(key: key);

  @override
  DataTabPageState createState() => DataTabPageState();
}

class DataTabPageState extends State<DataTabPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const DatasetChooser(),

          // A text view that takes up the remaining space and displays the
          // Rattle welcome and getting started message. This will be
          // overwritten once a dataset is loaded.

          Expanded(
            child: Center(
              key: const Key("rattle_welcome"),
              child: sunkenMarkdownFileBuilder(welcomeMsgFile),
            ),
          ),
        ],
      ),
    );
  }
}
