/// Settings provider.
//
// Time-stamp: <Thursday 2024-11-21 08:05:30 +1100 Graham Williams>
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
import 'package:shared_preferences/shared_preferences.dart';

// Define a provider for managing settings.

class SettingsNotifier extends StateNotifier<String> {
  // Default value.

  SettingsNotifier() : super('theme_rattle');

  void setGraphicTheme(String newTheme) {
    state = newTheme;
  }
}

// The provider we will use in the app.

class SettingsGraphicThemeNotifier extends StateNotifier<String> {
  static const _themeKey = 'graphic_theme';

  SettingsGraphicThemeNotifier() : super('theme_rattle') {
    _loadTheme();
  }

  void setGraphicTheme(String theme) async {
    state = theme;

    // Save the theme to shared_preferences.

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, theme);
  }

  Future<void> _loadTheme() async {
    // Load the theme from shared_preferences.

    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString(_themeKey) ?? 'theme_rattle';
  }
}

final settingsGraphicThemeProvider =
    StateNotifierProvider<SettingsGraphicThemeNotifier, String>(
  (ref) => SettingsGraphicThemeNotifier(),
);
