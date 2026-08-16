/// Test how an R error is told apart from output that mentions an error.
///
/// Time-stamp: "Sunday 2026-08-16 09:20:00 +1000 Graham Williams"
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

import 'package:flutter_test/flutter_test.dart';

import 'package:rattle/providers/r_status.dart';

void main() {
  group('rErrorReported turns the traffic light red for', () {
    test('an error from a call, as R words it', () {
      // Exactly as R reports it, from `log("a")`.

      expect(
        rErrorReported.hasMatch(
          'Error in log("a") : non-numeric argument to mathematical function',
        ),
        isTrue,
      );
    });

    test('an error from stop()', () {
      expect(rErrorReported.hasMatch('Error: boom'), isTrue);
    });

    test('an error part way through a longer chunk of console output', () {
      expect(
        rErrorReported.hasMatch(
          '> model <- rpart(form, data=ds)\n'
          'Error in eval(predvars, data, env) : object not found\n'
          '> ',
        ),
        isTrue,
      );
    });
  });

  group('rErrorReported leaves the traffic light green for', () {
    test('the error matrix, which reports errors as a measure', () {
      // The word error is everywhere in the EVALUATE output, and none of it
      // means R failed. This is why the pattern is anchored to the line start.

      expect(
        rErrorReported.hasMatch(
          'Overall Error = 16.67%; Average Error = 34.14%.',
        ),
        isFalse,
      );

      expect(
        rErrorReported.hasMatch('Error matrix for the Decision Tree model'),
        isFalse,
      );
    });

    test('ordinary output', () {
      expect(rErrorReported.hasMatch(''), isFalse);
      expect(
        rErrorReported.hasMatch('> ds <- read.csv("weather.csv")\n> '),
        isFalse,
      );
    });
  });
}
