/// The Rattle state of affairs.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Saturday 2023-09-30 16:34:33 +1000 Graham Williams>
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
import 'package:xterm/xterm.dart';

/// The global state of affairs for Rattle.
///
/// This [ChangeNotifier] records data that is maintained and access throughout
/// the app. This includes:
///
/// + **path** the dataset path, either a filename or package dataset name;
/// + **status** the current text to display in the status bar;
/// + **script** the monotonically growing R script capuring the user's interactions.

class RattleModel extends ChangeNotifier {
  // These global variables live here at the parent widget of the app.

  ////////////////////////////////////////////////////////////////////////
  // PATH
  //
  // When the [DatasetButton] updates the [_path] through [setPath] the
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

  ////////////////////////////////////////////////////////////////////////
  // STATUS - the content of the status bar at the bottom of the app.

  String _status = statusWelcomeMsg;

  String get status => _status;

  void setStatus(String newStatus) {
    _status = newStatus;
    notifyListeners();
  }

  ////////////////////////////////////////////////////////////////////////
  // SCRIPT - the developing script.
  //
  // Store the script being developed through the GUI. The initial value is
  // main.R and it gets appended to only as new scripts are run.

  String _script = "";

  String get script => _script;

  void appendScript(String newScript) {
    _script = _script + newScript;
    notifyListeners();
  }

  ////////////////////////////////////////////////////////////////////////
  // STDOUT - the ongoing output capture of standard output.

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

  ////////////////////////////////////////////////////////////////////////
  // STDERR - the ongoing output capture of standard error.

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

  ////////////////////////////////////////////////////////////////////////
  // MODEL - the currently active model type.
  //
  // Store the currently selected model type. This is one of Tree, Forest, etc.

  String _model = "Tree";

  String get model => _model;

  void setModel(String newModel) {
    _model = newModel;
    notifyListeners();
  }

  ////////////////////////////////////////////////////////////////////////
  // NORMALISE - Should we normalise the dataset on loading.

  bool _normalise = true;

  bool get normalise => _normalise;

  void setNormalise(bool newNormalise) {
    _normalise = newNormalise;
    notifyListeners();
  }

  ////////////////////////////////////////////////////////////////////////
  // PARTITION - Should we partition the dataset for analysis.

  bool _partition = true;

  bool get partition => _partition;

  void setPartition(bool newPartition) {
    _partition = newPartition;
    notifyListeners();
  }

  ////////////////////////////////////////////////////////////////////////
  // PROCESS

  // 20230930 gjw TDOD HOW TO PROPERLY HANDLE THE CONSOLE?

  Terminal _rterm = Terminal(maxLines: 10000);

  Terminal get rterm => _rterm;

  void setRterm(Terminal newRterm) {
    _rterm = newRterm;
    notifyListeners();
  }

  // TerminalController _rtermController = TerminalController();

  // TerminalController get rtermController => _rtermController;

  // void setRtermController(TerminalController newRtermController) {
  //   _rtermController = newRtermController;
  //   notifyListeners();
  // }

  ////////////////////////////////////////////////////////////////////////
  // INITIALISATION
  //
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
