/// Constants used for spacing different widget contexts.
//
// Time-stamp: <Tuesday 2024-10-15 08:38:55 +1100 Graham Williams>
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

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'package:flutter/material.dart';

// TODO 20240901 gjw CONSIDER THE gap PACKAGE FOR SLIGHTLY SIMPLER GAPs.

/// Spacing between rows in a ChoiceChip.

const choiceChipRowSpace = 10.0;

/// Space above the beginning of the configs Row.

const configTopSpace = SizedBox(height: 10);

/// Space below the last row of configs often to ensure the underline of numeric
/// paramaters is not lost.

const configBotSpace = SizedBox(height: 5);

/// Space between the config Rows.

const configRowSpace = SizedBox(height: 20);

/// Space to the left of the configs within a Row.

const configLeftSpace = SizedBox(width: 5);

/// Space between widgets in a Row in the the config.

const configWidgetSpace = SizedBox(width: 20.0); // Gap(20);

/// Space between widgets in a Row in the the config.

const configChooserSpace = SizedBox(width: 10.0); // Gap(20);
/// Space between a label and the field.

const configLabelSpace = SizedBox(width: 5);

/// Space before the bottom divider in the display pages.

const textPageBottomSpace = SizedBox(height: 20.0); //Gap(20);
