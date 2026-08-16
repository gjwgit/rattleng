/// Remember the size of the app window between sessions.
///
/// Time-stamp: "Sunday 2026-08-17 14:40:00 +1000 Graham Williams"
///
/// Copyright (C) 2026, Togaware Pty Ltd.
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://opensource.org/license/gpl-3-0
///
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
/// Authors: Aditya Arora, Graham Williams

library;

import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

import 'package:rattle/utils/is_desktop.dart';

/// The shared preferences the window size is remembered in.

const String windowWidthPref = 'windowWidth';
const String windowHeightPref = 'windowHeight';
const String rememberWindowSizePref = 'rememberWindowSize';

/// Save the current window size, so that the next session opens the same way.
///
/// 20260817 gjw This is called as the window is resized, and not only as the
/// app closes, because on the Linux desktop the app-lifecycle callbacks are not
/// reliably delivered on a window close. A size saved only on the way out is a
/// size lost whenever the app is closed by any other means.
///
/// Does nothing when the user has turned off remembering the size, leaving
/// whatever size they set through SETTINGS to be the size they get.

Future<void> saveWindowSize() async {
  if (!isDesktop) return;

  final prefs = await SharedPreferences.getInstance();

  if (!(prefs.getBool(rememberWindowSizePref) ?? true)) return;

  final Size size = await windowManager.getSize();

  // A window that has been minimised or is mid-transition can report a size of
  // no use to anybody, and saving it would leave the app unopenable at a
  // sensible size next time.

  if (size.width < 100 || size.height < 100) return;

  await prefs.setDouble(windowWidthPref, size.width);
  await prefs.setDouble(windowHeightPref, size.height);
}
