/// Wait for the output of an R command to appear in the R console.
///
/// Time-stamp: "Saturday 2026-08-15 10:12:00 +1000 Graham Williams"
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

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/providers/stdout.dart';
import 'package:rattle/r/extract.dart';

/// Return the output of the R [command], waiting for it to arrive.
///
/// The R process runs asynchronously through the pty, so the output of a script
/// that `rSource()` has just submitted is not in `stdoutProvider` by the time
/// `rSource()` returns. Poll until it is, rather than guess at a delay.
///
/// Only the console output produced since [from] is searched, so that the
/// result of a previous run of the same command is never mistaken for this
/// one. The caller records the length of `stdoutProvider` before submitting the
/// script and passes it here.
///
/// Return the empty string if nothing arrives within [timeout], which the
/// caller reports as the R command having failed. That is the honest outcome:
/// R may have raised an error, in which case the CONSOLE tab has the detail.

Future<String> waitForROutput(
  WidgetRef ref,
  String command, {
  required int from,
  Duration timeout = const Duration(seconds: 20),
}) async {
  const Duration interval = Duration(milliseconds: 100);

  for (int waited = 0;
      waited < timeout.inMilliseconds;
      waited += interval.inMilliseconds) {
    final String stdout = ref.read(stdoutProvider);

    if (stdout.length > from) {
      final String output = rExtract(stdout.substring(from), command);

      if (output.isNotEmpty) return output;
    }

    await Future.delayed(interval);
  }

  return '';
}
