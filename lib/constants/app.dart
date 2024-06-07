/// App-Wide Constants for RattleNG
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
//
// Time-stamp: <Saturday 2024-06-08 06:04:31 +1000 Graham Williams>
//
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

library;

import 'package:flutter/material.dart';

/// The Rattle app's title.

const String appTitle = 'Rattle the Next Generation Data Scientist';

/// Project assets folder path used in the APP.

const String assetsPath = 'assets';

/// Location of the markdown file containing the welcome message for the APP.

const String welcomeMsgFile = '$assetsPath/markdown/welcome.md';

/// Location of the markdown file containing instructions for the SCRIPT tab.

const String scriptIntroFile = '$assetsPath/markdown/script_intro.md';

/// A mono font used for displaying R script and output.

const monoTextStyle = TextStyle(
  fontFamily: 'RobotoMono',
  fontSize: 16,
);
const monoSmallTextStyle = TextStyle(
  fontFamily: 'RobotoMono',
  fontSize: 12,
);
