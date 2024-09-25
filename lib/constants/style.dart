/// Constants used for different widget text styles.
// Time-stamp: <Thursday 2024-09-26 08:23:26 +1000 Graham Williams>
//
/// Copyright (C) 2024, Togaware Pty Ltd
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
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

/// Text style for normal text.

const TextStyle normalTextStyle = TextStyle(
  fontSize: 14.0,
  color: Colors.black,
);

// A text style for disabled fields.

const TextStyle disabledTextStyle = TextStyle(
  fontSize: 14.0,
  color: Colors.grey, // Grey out the text
);

/// A mono font used for displaying R script and output.

const monoTextStyle = TextStyle(
  fontFamily: 'RobotoMono',
  fontSize: 16,
);

const monoSmallTextStyle = TextStyle(
  fontFamily: 'RobotoMono',
  fontSize: 12,
);
