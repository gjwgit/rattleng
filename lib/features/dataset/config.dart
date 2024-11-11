/// Widget to configure the dataset: button, path, clear, and toggles.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Friday 2024-06-07 13:59:17 +1000 Graham Williams>
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

import 'package:rattle/features/dataset/button.dart';
import 'package:rattle/features/dataset/clear_text_field.dart';
import 'package:rattle/features/dataset/text_field.dart';
import 'package:rattle/features/dataset/toggles.dart';

const double widthSpace = 5;

/// The dataset config allows selection and tuning of the data for Rattle.
///
/// The widget consists of a button to allow picking the dataset and a text
/// field where the dataset path or name is displayed or entered by the user
/// typing it in.
///
/// This is a StatefulWidget to record the name of the chosen dataset. TODO THE
/// DATASET NAME MAY NEED TO BE PUSHED HIGHER FOR ACCESS FROM OTHER PAGES.

class DatasetConfig extends StatefulWidget {
  const DatasetConfig({super.key});

  @override
  State<DatasetConfig> createState() => _DatasetConfigState();
}

class _DatasetConfigState extends State<DatasetConfig> {
  // A controller for the text field so it can be updated programmatically.

  // final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        // Some fixed space so the widgets aren't crowded.

        SizedBox(width: widthSpace),

        // Widget to select the dataset filename.

        DatasetButton(),

        SizedBox(width: widthSpace),

        // A text field to display the selected dataset name.

        DatasetTextField(),

        // Clear the textfield entry.

        DatasetClearTextField(),

        SizedBox(width: widthSpace),

        // Toggles to choose what to do on loading the dataset.

        DatasetToggles(),
      ],
    );
  }
}
