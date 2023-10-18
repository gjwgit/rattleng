/// Dataset tab for home page.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
//
// Time-stamp: <Wednesday 2023-10-18 17:25:44 +1100 Graham Williams>
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

import 'package:provider/provider.dart';

import 'package:rattle/constants/app.dart';
import 'package:rattle/constants/keys.dart';
import 'package:rattle/r/extract_glimpse.dart';
import 'package:rattle/models/rattle_model.dart';
import 'package:rattle/dataset/chooser.dart';
import 'package:rattle/widgets/markdown_file.dart';

// TODO 20230916 gjw DOES THIS NEED TO BE STATEFUL?

class DatasetTab extends StatefulWidget {
  const DatasetTab({Key? key}) : super(key: key);

  @override
  DatasetTabState createState() => DatasetTabState();
}

class DatasetTabState extends State<DatasetTab> {
  @override
  Widget build(BuildContext context) {
    return Consumer<RattleModel>(
      // Build a [Consumer] of the [RattleModel] so we can access updated
      // values of the path variable.
      builder: (context, rattle, child) {
        return Scaffold(
          body: Column(
            children: [
              const DatasetChooser(),

              // A text view that takes up the remaining space and displays the
              // Rattle welcome and getting started message. This will be
              // overwritten once a dataset is loaded.

              Visibility(
                visible: rattle.path == "",
                child: Expanded(
                  child: Center(
                    key: welcomeTextKey,
                    child: sunkenMarkdownFileBuilder(welcomeMsgFile),
                  ),
                ),
              ),
              Visibility(
                visible: rattle.path != "",
                child: Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(left: 10),
                    child: SelectableText(
                      rExtractGlimpse(rattle.stdout),
                      key: datasetGlimpseKey,
                      style: monoTextStyle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
