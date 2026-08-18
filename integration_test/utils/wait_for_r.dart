/// Wait until R has finished what it was asked to do.
///
/// Time-stamp: "Tuesday 2026-08-18 09:30:00 +1000 Graham Williams"
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
/// Authors: Graham Williams

library;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rattle/providers/r_status.dart';

/// Wait until R is finished and its output has arrived.
///
/// Our tests ask Rattle to do something and then look at what appeared. The
/// asking returns as soon as the R code has been handed to the R session, which
/// is long before R has finished with it, so a test that looks straight away
/// finds an empty page. Waiting a fixed number of seconds instead only moves
/// the problem: too short and the test fails on a slower machine, too long and
/// every test pays for the slowest.
///
/// This waits for the thing the app itself waits for. The traffic light in the
/// app bar is [RStatus.running] from the moment the code is handed to R and
/// turns [RStatus.ready] once R has gone quiet at its prompt, so a test can
/// wait for exactly as long as the work takes. See `providers/r_status.dart`.
///
/// [RStatus.failed] also ends the wait. R reported an error, so nothing more is
/// coming, and the test should get on and fail on what it was checking rather
/// than sit here until the timeout.

Future<void> waitForR(
  WidgetTester tester, {
  Duration timeout = const Duration(minutes: 5),
}) async {
  final ProviderContainer container = ProviderScope.containerOf(
    tester.element(find.byType(MaterialApp).first),
  );

  const Duration interval = Duration(milliseconds: 200);

  // First give R a moment to pick the work up. Until it does, the light is
  // still green from whatever went before, and waiting for green would return
  // at once and prove nothing. If it never goes amber then there was nothing
  // to wait for, so carry on rather than fail. Two seconds is plenty: the
  // light turns amber as `rSource()` hands the code over, not when R finishes
  // with it, and this is the whole cost of calling this where there was no
  // work to wait for.

  for (int waited = 0; waited < 2000; waited += interval.inMilliseconds) {
    if (container.read(rStatusProvider) != RStatus.ready) break;
    await tester.pump(interval);
  }

  // Then wait for R to finish.

  for (int waited = 0;
      waited < timeout.inMilliseconds;
      waited += interval.inMilliseconds) {
    if (container.read(rStatusProvider) != RStatus.running) {
      // Let the panels rebuild with what R reported.

      await tester.pumpAndSettle();

      return;
    }

    await tester.pump(interval);
  }

  fail('R was still running after ${timeout.inSeconds}s. '
      'The traffic light never turned green.');
}
