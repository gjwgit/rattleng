/// Constants used for spacing different widget contexts.
//
// Time-stamp: <Wednesday 2024-11-13 09:17:24 +1100 Graham Williams>
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

import 'package:gap/gap.dart';

/// A general gap used between buttons, like in the dataset popup.

const buttonGap = Gap(10);

/// Width between rows in a ChoiceChip.

const choiceChipRowSpace = 10.0;

/// Gap above the beginning of the configs Row.

const configTopGap = Gap(10);

/// Gap below the last row of configs often to ensure the underline of numeric
/// paramaters is not lost.

const configBotGap = Gap(5);

/// Gap between the config Rows.

const configRowGap = Gap(20);

/// Gap to the left of the configs within a Row.

const configLeftGap = Gap(5);

/// Gap between widgets in a Row in the config.

const configWidgetGap = Gap(20);

/// Gap between widgets in a Row in the the config.

const configChooserGap = Gap(10);

/// Gap between a label and the field.

const configLabelGap = Gap(5);

/// Gap between the title row of a popup between the icon and the text of the
/// title.

const popupIconGap = Gap(20);

/// Gap between a popup's title row and content.

const popupTitleGap = Gap(40);

/// Gap before the bottom divider in the display pages.

const textPageBottomGap = Gap(20);

/// Width to fit 5 ChoiceChips in a Row.

const choiceChipRowWidth = 400.0;
