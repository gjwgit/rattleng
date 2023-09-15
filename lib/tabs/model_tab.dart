/// First and Dataset page for the first Data tab.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
//
// Time-stamp: <Friday 2023-09-15 21:19:21 +1000 Graham Williams>
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
import 'package:rattle/helpers/r_extract_print_rpart.dart';
import 'package:rattle/helpers/r_source.dart';
import 'package:rattle/models/rattle_model.dart';
import 'package:rattle/widgets/dataset_chooser.dart';
import 'package:rattle/widgets/markdown_file.dart';

class ModelTab extends StatefulWidget {
  const ModelTab({Key? key}) : super(key: key);

  @override
  ModelTabState createState() => ModelTabState();
}

class ModelTabState extends State<ModelTab> {
  @override
  Widget build(BuildContext context) {
    return Consumer<RattleModel>(
      // Build a [Consumer] of the [RattleModel] so we can access updated
      // values of the path variable.

      builder: (context, rattle, child) {
        return Scaffold(
          body: Column(children: [
            ElevatedButton(
              onPressed: () async {
                rSource("model_template", rattle);
                rSource("rpart_build", rattle);
              },
              child: const Tooltip(
                message: "Click here to build rpart for now.",
                child: Text("Build Rpart"),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 0),
                child: SelectableText(
                  rExtractPrintRpart(rattle.stdout),
                  style: const TextStyle(
                    fontFamily: 'RobotoMono',
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ]),
        );
      },
    );
  }
}
