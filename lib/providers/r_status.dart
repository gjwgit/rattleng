/// A provider of the status of the R process, for the traffic light display.
///
/// Time-stamp: "Sunday 2026-08-16 09:20:00 +1000 Graham Williams"
///
/// Copyright (C) 2026, Togaware Pty Ltd.
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://opensource.org/license/gpl-3-0
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
// this program.  If not, see <https://opensource.org/license/gpl-3-0>.
///
/// Authors: Graham Williams

library;

import 'package:flutter_riverpod/legacy.dart';

/// What the R process is doing, as shown by the traffic light in the app bar.

enum RStatus {
  /// R is at its prompt, having completed what was asked of it. Green.

  ready,

  /// R is running our code. Yellow.

  running,

  /// R reported an error, or the R process is gone. Red.

  failed,
}

/// The R process starts out [RStatus.running] because it is: the R session is
/// started when the CONSOLE is first built, and the light turns green when R
/// settles at its prompt, having loaded. (gjw 20260816)

final rStatusProvider = StateProvider<RStatus>((ref) => RStatus.running);

/// How long R has to be quiet before we call it finished.
///
/// Long enough that the gap between R printing a prompt and echoing the next
/// statement of a script does not read as R having finished, and short enough
/// that the light turns green as soon as it has. (gjw 20260816)

const Duration rIdleDelay = Duration(milliseconds: 400);

/// How R reports an error, being `Error: ...` or `Error in <call> : ...` at the
/// start of a line.
///
/// Anchored so that output which merely mentions an error, such as the
/// `Overall Error = 16.67%` of the error matrix, is not mistaken for one.

final RegExp rErrorReported = RegExp(r'^Error(:| in )', multiLine: true);
