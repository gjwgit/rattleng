/// Utilities used for the tabs interface.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Monday 2023-09-11 14:16:04 +1000 Graham Williams>
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

import 'package:flutter/material.dart' show debugPrint;

import 'package:rattle/helpers/build_model.dart' show buildModel;
import 'package:rattle/helpers/load_dataset.dart' show loadDataset;

void processTab(String currentTab) {
  switch (currentTab) {
    case "Data":
      debugPrint(
        "HOME PAGE: DATA TAB ACTIVE SO LOAD THE DATASET",
      );
      loadDataset();
    case "Model":
      debugPrint(
        "HOME PAGE: MODEL TAB ACTIVE SO BUILD RPART",
      );
      buildModel();
    default:
      debugPrint(
        "HOME PAGE: RUN NOT IMPLEMENTED FOR $currentTab TAB",
      );
  }
}
