/// App-Wide Colors for RattleNG
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
//
// Time-stamp: <Saturday 2024-06-08 20:32:46 +1000 Graham Williams>
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

// Colour Options

// Color(0xff45035e) is a solid dark purple, suitable for white text. This
// standout colour could be the background used throughout the app.
//
// Color(0x5545035e) is a medium purple, suitable for black text. This can be a
// softer contrast to a darker purple as might be used for the tab areas at the
// top of the app.

// Color(0xfffef7ff) is a very pale (too pale) purple that looks somewhat washed
// out.

/// The default background colour of the header and side bar.

const headerBarColor = Colors.red; //Color(0xff45035e);

/// The default background colour of the tab bars in the header and side bars.

const tabBarColor = Colors.red; //Color(0xff45035e);

/// The default background colour for the configuration bars in each panel.

const configBarColor = Colors.red;

/// The default background colour for the configuration bars in each panel.

const panelBarColor = Colors.red; //Color(0xfffef7ff);

/// The default background colour of the status bar at the bottom of the app.

final statusBarColor = Colors.deepPurple.shade100;

/// A [BoxDecoration] with a sunken effect for use with a [Container]'s
/// decortation.

final sunkenBoxDecoration = BoxDecoration(
  color: Colors.white,
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withOpacity(1),
      spreadRadius: 10,
      blurRadius: 10,
      offset: const Offset(10, 10),
    ),
  ],
);
