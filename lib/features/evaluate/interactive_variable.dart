/// A model input variable to be filled in through the INTERACTIVE popup.
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

import 'dart:convert';

/// One model input variable, as described by `evaluate_interactive_variables.R`.

class InteractiveVariable {
  /// The variable name, as it is known to the dataset and so to the model.

  final String name;

  /// One of `numeric`, `categoric` or `other`.

  final String datatype;

  /// The values a categoric variable can take, empty for any other datatype.

  final List<String> levels;

  /// The value the field starts at, being the mean of a numeric variable and
  /// the most common level of a categoric one, so that a prediction can be made
  /// without having to fill in every field.

  final String initialValue;

  const InteractiveVariable({
    required this.name,
    required this.datatype,
    required this.levels,
    required this.initialValue,
  });

  bool get isCategoric => datatype == 'categoric';

  bool get isNumeric => datatype == 'numeric';

  /// Parse the JSON that `evaluate_interactive_variables.R` reports.
  ///
  /// Returns the empty list if the JSON is not what we expect, which the popup
  /// reports as not having been able to identify the variables rather than
  /// throwing up an exception at the user.

  static List<InteractiveVariable> fromJson(String json) {
    late final Map<String, dynamic> decoded;

    try {
      final dynamic parsed = jsonDecode(json);
      if (parsed is! Map<String, dynamic>) return [];
      decoded = parsed;
    } on FormatException {
      return [];
    }

    return decoded.entries.map((entry) {
      final Map<String, dynamic> value = entry.value as Map<String, dynamic>;

      // R's `auto_unbox` reports a single level as a string rather than as a
      // list of one, so accept both. (gjw 20260815)

      final dynamic levels = value['levels'];

      return InteractiveVariable(
        name: entry.key,
        datatype: (value['datatype'] ?? 'other').toString(),
        levels: levels == null
            ? <String>[]
            : levels is List
                ? levels.map((level) => level.toString()).toList()
                : <String>[levels.toString()],
        initialValue: (value['value'] ?? '').toString(),
      );
    }).toList();
  }

  /// This variable set to [value], as an argument to R's `data.frame()`.
  ///
  /// The name is quoted with backticks, and `check.names` is left to the caller
  /// to disable, so that a variable name R would otherwise rewrite reaches the
  /// model as the name it was trained on.

  String rArgument(String value) {
    if (value.trim().isEmpty) return '`$name` = NA';

    if (isNumeric) {
      // Anything that is not a number is passed as a missing value, which the
      // model reports as it sees fit, rather than as R code we cannot parse.

      final double? number = double.tryParse(value.trim());

      return '`$name` = ${number ?? 'NA'}';
    }

    // A level could contain a quote or a backslash, so escape both.

    final String escaped = value.replaceAll(r'\', r'\\').replaceAll('"', r'\"');

    return '`$name` = "$escaped"';
  }
}
