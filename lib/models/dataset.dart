/// Rattle dataset related state of affairs.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Thursday 2023-10-19 06:32:53 +1100 Graham Williams>
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
import 'package:rattle/constants/status.dart';
import 'package:xterm/xterm.dart';

/// The global state of affairs for the Rattle dataset.
///
/// This [ChangeNotifier] records data that is maintained and access throughout
/// the app. This includes:
///
/// + **path** the dataset path, either a filename or package dataset name;
/// + **status** the current text to display in the status bar;
/// + **script** the monotonically growing R script capuring the user's interactions.

class DatasetModel extends ChangeNotifier {
  // These global variables live here at the parent widget of the app.

  // TODO 20231018 gjw DO I WANT TO MOVE ALL THE DATASET VARS INTO
  // models/dataset.dart, AND MODEL VARS TO models/models.dart, ETC?

  // Reset the dataset variables.

  void reset() {
    setTarget("");
    setRisk("");
    setIdentifiers("");
    setIgnore("");
  }

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
  // VARS - A list of the names of the variables of the dataset.

  List<String> _vars = [];

  List<String> get vars => _vars;

  void setVars(List<String> newVars) {
    _vars = newVars;
    notifyListeners();
  }

  ////////////////////////////////////////////////////////////////////////
  // TARGET - A list of the names of the variables of the dataset.

  String _target = "";

  String get target => _target;

  void setTarget(String newTarget) {
    _target = newTarget;
    notifyListeners();
  }

  ////////////////////////////////////////////////////////////////////////
  // RISK - A list of the names of the variables of the dataset.

  String _risk = "";

  String get risk => _risk;

  void setRisk(String newRisk) {
    _risk = newRisk;
    notifyListeners();
  }

  ////////////////////////////////////////////////////////////////////////
  // IDENTIFIERS - A list of the names of the variables of the dataset.

  String _identifiers = "";

  String get identifiers => _identifiers;

  void setIdentifiers(String newIdentifiers) {
    _identifiers = newIdentifiers;
    notifyListeners();
  }

  ////////////////////////////////////////////////////////////////////////
  // IGNORE - A list of the names of the variables of the dataset.

  String _ignore = "";

  String get ignore => _ignore;

  void setIgnore(String newIgnore) {
    _ignore = newIgnore;
    notifyListeners();
  }

  ////////////////////////////////////////////////////////////////////////
  // INITIALISATION
  //
  // Constructor to load/set the initial values, if required.

  DatasetModel() {
    _loadInitialValues();
  }

  Future<void> _loadInitialValues() async {
    null;
  }
}
