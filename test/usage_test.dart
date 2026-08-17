/// Test that the command line usage message is the same wherever it comes from.
///
/// Time-stamp: "Sunday 2026-08-17 16:20:00 +1000 Graham Williams"
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

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:rattle/main.dart';

void main() {
  group('the command line usage message', () {
    test('is the same in the Linux runner as it is in Dart', () {
      // `--help` is answered twice: by the Linux runner, before any window is
      // created, and by `main()` for the other desktops. The message is
      // therefore written out twice, in C and in Dart, and this is what keeps
      // the two saying the same thing.

      final String runner = File('linux/my_application.cc').readAsStringSync();

      // The C message is `kUsage`, a run of adjacent string literals, one per
      // line, up to the semicolon.

      final Match? block = RegExp(
        r'kUsage\s*=\s*((?:\s*"(?:[^"\\]|\\.)*"\s*)+);',
      ).firstMatch(runner);

      expect(
        block,
        isNotNull,
        reason: 'no kUsage message found in the Linux runner',
      );

      final String fromRunner = RegExp(r'"((?:[^"\\]|\\.)*)"')
          .allMatches(block!.group(1)!)
          .map((literal) => literal.group(1)!)
          .join()
          .replaceAll(r'\n', '\n')
          .replaceAll('%s', 'rattle');

      // The runner prints its own trailing newline, which `stdout.writeln()`
      // adds for the Dart message.

      expect(fromRunner, '${usage('rattle')}\n');
    });

    test('lets through the arguments that macOS adds for itself', () {
      // Rattle cannot be tested on macOS from here, and getting this wrong
      // would stop the app starting at all when launched from the Finder or
      // from Xcode, so the predicate is pinned down here.

      for (final launch in [
        '-psn_0_1234567',
        '-NSDocumentRevisionsDebugMode',
        '-ApplePersistenceIgnoreState',
      ]) {
        expect(
          isLaunchArgument(launch),
          isTrue,
          reason: '$launch is added by macOS and must not be reported',
        );
      }
    });

    test('reports anything else that looks like an option', () {
      for (final mistake in ['--xxx', '-q', '--verison', '-']) {
        expect(
          isLaunchArgument(mistake),
          isFalse,
          reason: '$mistake is not a macOS launch argument',
        );
      }
    });

    test('names every argument that Rattle acts on', () {
      final String message = usage('rattle');

      for (final argument in ['--help', '-h', '--version', '-v']) {
        expect(
          message,
          contains(argument),
          reason: '$argument is accepted but not mentioned in the usage',
        );
      }

      // The dataset argument is recognised by its extension, so the usage has
      // to say which ones. See `datasetExtensions` in `constants/app.dart`.

      for (final extension in ['csv', 'xlsx', 'txt']) {
        expect(message, contains(extension));
      }
    });
  });
}
