/// Constants used for spacing different widget contexts.
//
// Time-stamp: <Saturday 2024-12-14 21:15:05 +1100 Graham Williams>
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

// 20241214 gjw On moving to using the `spacing:` parameter of `Column()` the top gap is
// added to the default spacing. So we now set it to 0 so that we get the same
// as the spacing between rows. This is a little larger than previously, but is
// okay, giving a little less crowded look.

const configTopGap = Gap(0);

/// Gap below the last row of configs often to ensure the underline of numeric
/// paramaters is not lost.

// 20241214 gjw On moving to using the `spacing:` parameter of `Column()` the top gap is
// added to the default spacing. So we now set it to 0 so that we get the same
// as the spacing between rows. This is a little larger than previously, but is
// okay, giving a little less crowded look.

const configBotGap = Gap(0);

/// Gap between the config Rows.

const configRowGap = Gap(20);

// 20241214 gjw Migrate to Flutter 3.27 Row/Column introduction of `spacing:`.

const configRowSpace = 20.0;

/// Gap to the left of the configs within a Row.

// 20241214 gjw On moving to using the `spacing:` parameter of `Row()` the left
// gap is added to the default spacing. So we now set it to 0 so that we get the
// same as the spacing between widgets. This is a little larger than previously,
// but is okay, giving a little less crowded look.

const configLeftGap = Gap(0);

/// Gap between widgets in a Row in the config.

const configWidgetGap = Gap(20);

// 20241214 gjw Migrate to Flutter 3.27 Row/Column introduction of `spacing:`.

const configWidgetSpace = 20.0;

/// Gap between widgets in a Row in the the config.

const configChooserGap = Gap(10);

/// Gap between a label and the field.

const configLabelGap = Gap(5);

/// Gap between the title row of a popup between the icon and the text of the
/// title.

const popupIconGap = Gap(20);

/// Gap between a popup's title row and content.

const popupTitleGap = Gap(40);

/// Gap between a popup's title row and content.

const settingsGroupGap = Gap(40);

/// Gap before the bottom divider in the display pages.

const textPageBottomGap = Gap(20);

/// Gap in height between widgets.

const panelGap = Gap(10);

/// Width to fit 5 ChoiceChips in a Row.

const choiceChipRowWidth = 400.0;
