/// Check if we are running a desktop (and not a browser).
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Wednesday 2023-11-01 08:40:11 +1100 Graham Williams>
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

import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:universal_io/io.dart' show Platform;

/// Test if we are running on a desktop platform and not in a browser.

bool get isDesktop {
  if (kIsWeb) return false;

  return Platform.isLinux || Platform.isMacOS || Platform.isWindows;

  // Another approach is:

  // return [
  //   TargetPlatform.windows,
  //   TargetPlatform.linux,
  //   TargetPlatform.macOS,
  // ].contains(defaultTargetPlatform);
}
