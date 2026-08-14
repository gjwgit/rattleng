/// Gloabl variable [cleaning].
///
/// Copyright (C) 2023-2025, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://opensource.org/license/gpl-3-0
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
// this program.  If not, see <https://opensource.org/license/gpl-3-0>.
///
/// Authors: Graham Williams

library;

import 'package:flutter_riverpod/legacy.dart';

/// Whether to cleanse the data or not. Default is true.

final cleanseProvider = StateProvider<bool>((ref) => true);

/// The default maximum number of unique values for a character column to be a
/// factor.

const int defaultMaxFactor = 20;

/// The maximum number of unique values for a character column to be a factor.
///
/// 20260815 gjw The provider simply returns the default. It previously loaded
/// the saved value from SharedPreferences in a microtask which read the
/// provider itself, and riverpod asserts against that: "A provider cannot
/// depend on itself". A provider genuinely can not initialise itself this way
/// since its controller is only created after this function returns. The saved
/// value is instead loaded on startup by `features/dataset/toggles.dart` and on
/// opening the SETTINGS dialog, as is done for the random seed and the
/// partition ratios. Resetting the setting is then simply an invalidate of the
/// provider, which was previously racing with the microtask reloading the old
/// saved value.

final maxFactorProvider = StateProvider<int>((ref) => defaultMaxFactor);
