/// The Project state of affairs.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Monday 2023-10-30 05:28:07 +1100 Graham Williams>
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

typedef ProjectID = String;

class Project {
  /// Each project will have an identifier. Possily user specified and defaults
  /// to the basename of the project [path].

  final ProjectID id;

  /// Each project has a [path] that identifies where the dataset is to be loaded
  /// from.

  final String path;

  /// A project is actually completely defined by the R [script] that is built
  /// up through the user interacting with the app.

  final String script;

  Project({
    required this.id,
    this.path = "rattle::weather",
    this.script = "",
  });
}
