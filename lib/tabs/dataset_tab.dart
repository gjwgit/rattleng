/// Dataset tab for home page.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
//
// Time-stamp: <Saturday 2023-09-16 08:05:23 +1000 Graham Williams>
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
import 'package:rattle/helpers/r_extract_glimpse.dart';
import 'package:rattle/models/rattle_model.dart';
import 'package:rattle/widgets/dataset_chooser.dart';
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
                    key: const Key("rattle_welcome"),
                    child: sunkenMarkdownFileBuilder(welcomeMsgFile),
                  ),
                ),
              ),
              Visibility(
                visible: rattle.path != "",
                child: Expanded(
                  child: Container(
                    // I am setting the height for the bottom bar but this does not really
                    // seem to be the way to do this.
                    //height: 50,
                    padding: const EdgeInsets.only(left: 0),
                    child: SelectableText(
                      rExtractGlimpse(rattle.stdout),
                      style: const TextStyle(
                        fontFamily: 'RobotoMono',
                        fontSize: 16,
                      ),
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
