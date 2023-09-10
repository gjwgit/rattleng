/// An  text field file picker to choose the dataset for analysis.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
// Licensed under the GNU General Public License, Version 3 (the "License");
///
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

import 'package:rattle/models/dataset_model.dart';

class DatasetTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DatasetModel>(
      builder: (context, dataset, child) {
        return Expanded(
          child: TextField(
            key: const Key('ds_path_text'),
            onChanged: (newPath) {
              dataset.setPath(newPath);
            },
            decoration: const InputDecoration(
              hintText:
                  'Path to dataset file or named dataset from a package. {dataset}',
            ),
            controller: TextEditingController(text: dataset.path),
          ),
        );
      },
    );
  }
}
