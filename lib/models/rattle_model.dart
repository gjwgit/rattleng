/// The Rattle state of affairs.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Tuesday 2023-09-19 19:49:41 +1000 Graham Williams>
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
import 'package:flutter/services.dart' show rootBundle;

import 'package:rattle/constants/app.dart';

/// The global state of affairs for Rattle.
///
/// This [ChangeNotifier] records data that is maintained and access throughout
/// the app. This includes:
///
/// + **path** the dataset path, either a filename or package dataset name;
/// + **status** the current text to display in the status bar;
/// + **script** the monotonically growing R script capuring the user's interactions.

class RattleModel extends ChangeNotifier {
  // The [_path] lives here at the parent widget of the app. When the
  // [DatasetButton] updates the [_path] through [setPath] the
  // [DatasetTextField] [Consumes] the new value and is rebuilt.

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

  // Store the script being developed through the GUI. The initial value is
  // main.R and it gets appended to only as new scripts are run.

  String _script = "";

  String get script => _script;

  void appendScript(String newScript) {
    _script = _script + newScript;
    notifyListeners();
  }

  // Store the script being developed through the GUI. The initial value is
  // main.R and it gets appended to only as new scripts are run.

  String _stdout = "";

  String get stdout => _stdout;

  void appendStdout(String newStdout) {
    _stdout = _stdout + newStdout;
    notifyListeners();
  }

  void clearStdout() {
    _stdout = "";
    notifyListeners();
  }

  // Store the script being developed through the GUI. The initial value is
  // main.R and it gets appended to only as new scripts are run.

  String _stderr = "";

  String get stderr => _stderr;

  void appendStderr(String newStderr) {
    _stderr = _stderr + newStderr;
    notifyListeners();
  }

  void clearStderr() {
    _stderr = "";
    notifyListeners();
  }

  // Store the currently selected model type.

  String _model = "";

  String get model => _model;

  void setModel(String newModel) {
    _model = newModel;
    notifyListeners();
  }

  // Constructor to load the initial values, if required, from asset files.

  RattleModel() {
    _loadInitialValues();
  }

  Future<void> _loadInitialValues() async {
    try {
      final String assetContent =
          '## -- main.R --\n\n${await rootBundle.loadString("$assetsPath/r/main.R")}';
      _script = assetContent;
      notifyListeners();
    } catch (e) {
      // Handle any exceptions here
      debugPrint('Error loading asset: $e');
    }
  }
}
