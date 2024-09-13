/// Settings provider.
//
// Time-stamp: <Sunday 2024-09-08 12:15:34 +1000 Graham Williams>
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

import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define a provider for managing settings.

class SettingsNotifier extends StateNotifier<String> {
  // Default value.

  SettingsNotifier() : super('theme_rattle');

  void setGraphicTheme(String newTheme) {
    state = newTheme;
  }
}

// The provider we will use in the app.

final settingsGraphicThemeProvider =
    StateNotifierProvider<SettingsNotifier, String>((ref) {
  return SettingsNotifier();
});
