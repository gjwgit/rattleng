/// Gloabl variable [cleaning].
///
/// Copyright (C) 2023-2025, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: "Tuesday 2025-03-25 16:49:35 +1100 Graham Williams"
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

/// Whether to cleanse the data or not. Default is true.

final cleanseProvider = StateProvider<bool>((ref) => true);

/// The maximum number of unique values for a character column to be a factor.
/// This provider is initially set to 20, and then updated asynchronously with
/// the saved value from SharedPreferences if available.

final StateProvider<int> maxFactorProvider = StateProvider<int>((ref) {
  const int defaultValue = 20;

  // Schedule a microtask to load the saved value from SharedPreferences.

  Future.microtask(() async {
    final prefs = await SharedPreferences.getInstance();
    final storedValue = prefs.getInt('maxFactor') ?? defaultValue;

    // Update the provider only if the stored value is different.

    if (ref.read(maxFactorProvider.notifier).state != storedValue) {
      ref.read(maxFactorProvider.notifier).state = storedValue;
    }
  });

  return defaultValue;
});
