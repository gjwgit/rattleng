/// The Rattle state of affairs.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Wednesday 2023-09-13 06:15:41 +1000 Graham Williams>
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

import 'package:rattle/constants/app.dart';

class RattleModel extends ChangeNotifier {
  /// Internal dataset name.

  // The [_path] lives here at the parent widget of both DatasetButton (a button
  // for choosing a file) and the DatasetTextField. When the DatasetButton
  // updates the [_path] through [setPath] the DatasetTextField consumes the new
  // value and is rebuilt from above.

  String _path = "";

  String get path => _path;

  /// Record the dataset path through [setPath].

  void setPath(String newPath) {
    // First set the path to the new value.

    _path = newPath;

    // Then notify the widgets that are listening to this model to rebuild with
    // the new bit of context, the new value of the path.

    notifyListeners();
  }

  String _status = statusWelcomeMsg;

  String get status => _status;

  void setStatus(String newStatus) {
    _status = newStatus;
    notifyListeners();
  }

  String _output = "";

  String get output => _output;

  void setOutput(String newOutput) {
    _output = newOutput;
    notifyListeners();
  }
}
