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
import 'package:rattle/providers/stdout.dart';

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
/// An error does not end the wait. R carries on with the rest of the code it
/// was given after an error at the top level, so there is still output to come,
/// and the light stays red for the user to see rather than turning green. So on
/// [RStatus.failed] we wait on the console itself going quiet at a prompt, which
/// is the condition the light is built on. See `providers/pty.dart`.

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

  String previous = '';
  int quiet = 0;

  for (int waited = 0;
      waited < timeout.inMilliseconds;
      waited += interval.inMilliseconds) {
    final RStatus status = container.read(rStatusProvider);

    if (status == RStatus.ready) {
      // Let the panels rebuild with what R reported.

      await tester.pumpAndSettle();

      return;
    }

    if (status == RStatus.failed) {
      // 20260819 gjw R reported an error, and the light stays red so the user
      // can see it, so it will not turn green for us to wait on. R does not
      // stop at an error though: it carries on with the rest of the code it was
      // given. So wait on what the light itself waits on, the console going
      // quiet at a prompt. Returning as soon as the light went red let the test
      // run on while R was still working, and whether that mattered came down
      // to how fast the machine was.

      final String out = container.read(stdoutProvider);

      quiet = out == previous ? quiet + interval.inMilliseconds : 0;
      previous = out;

      if (quiet >= rIdleDelay.inMilliseconds && out.endsWith('> ')) {
        await tester.pumpAndSettle();

        return;
      }
    }

    await tester.pump(interval);
  }

  // 20260819 gjw Report what R last said. The light turns green once the
  // console has gone quiet AND ends at R's prompt (see `providers/pty.dart`),
  // and the check for the prompt is on the very end of the output, so the tail
  // is what decides the question -- down to the whitespace, which is why it is
  // escaped here rather than printed as it is. A hang of this kind happens
  // perhaps once in a hundred runs and cannot be asked for, so the failure has
  // to carry its own evidence.

  final String out = container.read(stdoutProvider);
  final String tail = out.length > 300 ? out.substring(out.length - 300) : out;

  fail('R was still running after ${timeout.inSeconds}s. '
      'The traffic light never turned green.\n'
      'The R console ended as follows, with | marking the very end:\n'
      '${tail.replaceAll('\n', r'\n').replaceAll('\r', r'\r')}|');
}
