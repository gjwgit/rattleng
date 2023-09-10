/// The dataset model to contain the state data.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Monday 2023-09-11 07:38:27 +1000 Graham Williams>
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

import 'package:flutter/foundation.dart';

class DatasetModel extends ChangeNotifier {
  /// Internal dataset name.

  // The [datasetPath] lives here as the parent widget of both DatasetButton (a
  // button for choosing a file) and the dataset path text field (which should
  // probably be a separate widget class. When the DatasetButton updates the
  // [datasetPath] then the TextField needs to be rebuilt from here
  // (above). Currently 20230910 in DatasetButton I am using find() to get the
  // TextField widget and to update it - bad approach - imperative rather than
  // declarative. Instead DatasetButton should update the datasetPath and and
  // then this class somehow knows to rebuild the TextField.

  String path = "";

  /// Record the dataset path as [setPath].

  void setPath(String newPath) {
    path = newPath;
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Return the current value of the dataset path.

  String getPath() {
    notifyListeners();
    return path;
  }
}
