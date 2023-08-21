/// First and Dataset page for the first Data tab.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
//
// Time-stamp: <Monday 2023-08-21 08:41:41 +1000 Graham Williams>
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

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:rattle/constants/app.dart';
import 'package:rattle/widgets/file_picker_ds.dart';
import 'package:rattle/widgets/markdown_file.dart';

class DataTabPage extends StatefulWidget {
  const DataTabPage({Key? key}) : super(key: key);

  @override
  _DataTabPageState createState() => _DataTabPageState();
}

class _DataTabPageState extends State<DataTabPage> {
  // Declare a variable to store the text entered by the user
  String _dsPath = '';

  // Declare a controller for the text field
  TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              // Widget to select the dataset filename.

              FilePickerDS(),

              // Some fixed space so the widgets aren't crowded.

              SizedBox(width: 5),

              // A text field to display the selected dataset name.

              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: 'Path to dataset file.',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _dsPath = value;
                    });
                  },
                ),
              ),
            ],
          ),

          // A text view that takes up the remaining space and displays the
          // Rattle welcome and getting started message. This will be
          // overwritten once a dataset is loaded.

          Expanded(
            child: Center(
              key: Key("rattle_welcome"),
              child: sunkenMarkdownFileBuilder(rattleWelcome),
            ),
          ),
        ],
      ),
    );
  }
}
