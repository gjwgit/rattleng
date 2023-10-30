/// Model tab for home page.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
//
// Time-stamp: <Saturday 2023-10-28 08:13:55 +1100 Graham Williams>
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

import 'package:rattle/src/constants/app.dart';
import 'package:rattle/src/features/model/radio_buttons.dart';
//import 'package:rattle/src/models/rattle_model.dart';

// TODO 20230916 gjw DOES THIS NEED TO BE STATEFUL?

class ModelTab extends StatefulWidget {
  const ModelTab({Key? key}) : super(key: key);

  @override
  ModelTabState createState() => ModelTabState();
}

class ModelTabState extends State<ModelTab> {
  @override
  Widget build(BuildContext context) {
//    return Consumer<RattleModel>(
//      builder: (context, rattle, child) {
    return Scaffold(
      body: Column(
        children: [
          const ModelRadioButtons(),
          const Visibility(
            visible: false, //rattle.model == "Cluster",
            child: Column(
              children: <Widget>[
                SizedBox(height: 50),
                Text("NOT YET IMPLEMENTED"),
              ],
            ),
          ),
          const Visibility(
            visible: false, //rattle.model == "Associate",
            child: Column(
              children: <Widget>[
                SizedBox(height: 50),
                Text("NOT YET IMPLEMENTED"),
              ],
            ),
          ),
          Visibility(
            visible: true, //rattle.model == "Tree",
            child: Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 10),
                child: const SingleChildScrollView(
                  child: SelectableText(
                    "rExtractTree(rattle.stdout)",
                    style: monoTextStyle,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: false, //rattle.model == "Forest",
            child: Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 10),
                child: const SingleChildScrollView(
                  child: SelectableText(
                    "rExtractForest(rattle.stdout)",
                    style: monoTextStyle,
                  ),
                ),
              ),
            ),
          ),
          const Visibility(
            visible: false, //rattle.model == "Boost",
            child: Column(
              children: <Widget>[
                SizedBox(height: 50),
                Text("NOT YET IMPLEMENTED"),
              ],
            ),
          ),
          const Visibility(
            visible: false, //rattle.model == "SVM",
            child: Column(
              children: <Widget>[
                SizedBox(height: 50),
                Text("NOT YET IMPLEMENTED"),
              ],
            ),
          ),
          const Visibility(
            visible: false, //rattle.model == "Linear",
            child: Column(
              children: <Widget>[
                SizedBox(height: 50),
                Text("NOT YET IMPLEMENTED"),
              ],
            ),
          ),
          const Visibility(
            visible: false, //rattle.model == "Neural",
            child: Column(
              children: <Widget>[
                SizedBox(height: 50),
                Text("NOT YET IMPLEMENTED"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
