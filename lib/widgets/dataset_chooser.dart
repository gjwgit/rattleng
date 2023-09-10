/// Widget to choose a dataset consisting of a button and text field.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Monday 2023-09-11 08:06:19 +1000 Graham Williams>
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

import 'package:rattle/widgets/dataset_button.dart';

/// The dataset chooser to allow selection of the data for Rattle.
///
/// The widget consists of a button to allow picking the dataset and a text
/// field where the dataset path or name is displayed or entered by the user
/// typing it in.
///
/// This is a StatefulWidget to record the name of the chosen dataset. TODO THE
/// DATASET NAME MAY NEED TO BE PUSHED HIGHR FOR ACCESS FROM OTHER PAGES.

class DatasetChooser extends StatefulWidget {
  const DatasetChooser({super.key});

  @override
  State<DatasetChooser> createState() => _DatasetChooserState();
}

class _DatasetChooserState extends State<DatasetChooser> {
  // The [datasetPath] lives here as the parent widget of both DatasetButton (a
  // button for choosing a file) and the dataset path text field (which should
  // probably be a separate widget class. When the DatasetButton updates the
  // [datasetPath] then the TextField needs to be rebuilt from here
  // (above). Currently 20230910 in DatasetButton I am using find() to get the
  // TextField widget and to update it - bad approach - imperative rather than
  // declarative. Instead DatasetButton should update the datasetPath and and
  // then this class somehow knows to rebuild the TextField.

  String datasetPath = "";

  // A controller for the text field so it can be updated programmatically.

  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Some fixed space so the widgets aren't crowded.

        const SizedBox(width: 5),

        // Widget to select the dataset filename.

        const DatasetButton(),

        // Some fixed space so the widgets aren't crowded.

        const SizedBox(width: 5),

        // A text field to display the selected dataset name.

        Expanded(
          child: TextField(
            key: const Key('ds_path_text'),
            controller: _textController,
            decoration: const InputDecoration(
              hintText: 'Path to dataset file or named dataset from a package.',
            ),
          ),
        ),
      ],
    );
  }
}
