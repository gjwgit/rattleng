/// Test the parsing of the INTERACTIVE prediction input variables.
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

import 'package:flutter_test/flutter_test.dart';

import 'package:rattle/features/evaluate/interactive_variable.dart';

void main() {
  // The JSON here is exactly what `evaluate_interactive_variables.R` reported
  // for the weather dataset, so the test fails if either side drifts.

  const String weatherJson = '{'
      '"min_temp":{"datatype":"numeric","min":-6.2,"max":20.8,"value":6.652},'
      '"wind_dir_9am":{"datatype":"categoric",'
      '"levels":["E","ENE","N","NNW","NW","S"],"value":"NNW"},'
      '"rain_today":{"datatype":"categoric","levels":["No","Yes"],'
      '"value":"No"}}';

  group('InteractiveVariable.fromJson', () {
    test('reads the datatype, levels and starting value of each variable', () {
      final vars = InteractiveVariable.fromJson(weatherJson);

      expect(vars.length, 3);

      expect(vars[0].name, 'min_temp');
      expect(vars[0].isNumeric, isTrue);
      expect(vars[0].levels, isEmpty);
      expect(vars[0].initialValue, '6.652');

      expect(vars[1].name, 'wind_dir_9am');
      expect(vars[1].isCategoric, isTrue);
      expect(vars[1].levels, ['E', 'ENE', 'N', 'NNW', 'NW', 'S']);
      expect(vars[1].initialValue, 'NNW');

      expect(vars[2].levels, ['No', 'Yes']);
    });

    test('accepts a single level, which R reports unboxed as a string', () {
      final vars = InteractiveVariable.fromJson(
        '{"flag":{"datatype":"categoric","levels":"Yes","value":"Yes"}}',
      );

      expect(vars.single.levels, ['Yes']);
    });

    test('returns no variables rather than throwing on unusable output', () {
      expect(InteractiveVariable.fromJson(''), isEmpty);
      expect(InteractiveVariable.fromJson('Error in ds : not found'), isEmpty);
      expect(InteractiveVariable.fromJson('[1, 2, 3]'), isEmpty);
    });
  });

  group('InteractiveVariable.rArgument', () {
    final numeric = InteractiveVariable.fromJson(weatherJson).first;
    final categoric = InteractiveVariable.fromJson(weatherJson)[1];

    test('passes a number through unquoted', () {
      expect(numeric.rArgument('7.3'), '`min_temp` = 7.3');
      expect(numeric.rArgument(' -2.5 '), '`min_temp` = -2.5');
    });

    test('passes a level as a quoted string', () {
      expect(categoric.rArgument('NNW'), '`wind_dir_9am` = "NNW"');
    });

    test('passes an empty field as a missing value', () {
      expect(numeric.rArgument(''), '`min_temp` = NA');
      expect(categoric.rArgument('   '), '`wind_dir_9am` = NA');
    });

    test('passes a number that is not a number as a missing value', () {
      // Otherwise the text would land in the R code as a bare symbol.

      expect(numeric.rArgument('warm'), '`min_temp` = NA');
    });

    test('escapes a quote and a backslash in a level', () {
      expect(categoric.rArgument(r'a"b'), r'`wind_dir_9am` = "a\"b"');
      expect(categoric.rArgument(r'a\b'), r'`wind_dir_9am` = "a\\b"');
    });
  });
}
