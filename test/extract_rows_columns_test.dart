/// Test the extraction of the dataset dimensions for the status bar.
//
// Time-stamp: <Wednesday 2026-08-19 11:00:00 +1000 Graham Williams>
//
/// Copyright (C) 2026, Togaware Pty Ltd
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://opensource.org/license/gpl-3-0
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

import 'package:rattle/r/extract_rows_columns.dart';

void main() {
  group('rExtractRowsColumns', () {
    test('reports the dimensions from a glimpse', () {
      expect(
        rExtractRowsColumns('Rows: 366\nColumns: 23\n'),
        '366 x 23',
      );
    });

    test('handles thousands separators', () {
      expect(
        rExtractRowsColumns('Rows: 20,000\nColumns: 12\n'),
        '20,000 x 12',
      );
    });

    test('nothing to report where R said nothing', () {
      expect(rExtractRowsColumns(''), '');
    });

    // 20260819 gjw The status bar is on screen whatever the user is doing, so
    // anything it throws comes back on every frame and takes the whole window
    // with it. That is what a single line of input used to do here, and a
    // single line is what is left when R never produced a glimpse -- an R
    // package that fails to load leaves the dataset unloaded. The user was
    // shown the advice about installing the package over a grey screen and
    // could do nothing but dismiss it and restart Rattle.

    test('a single line does not throw', () {
      expect(rExtractRowsColumns('Rows: 366'), '');
    });

    test('a line with no numbers does not throw', () {
      expect(rExtractRowsColumns('there is no package called ggplot2'), '');
    });
  });
}
