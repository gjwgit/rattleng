/// Map word cloud feature template patterns to their values.
///
// Time-stamp: "Friday 2025-09-12 14:16:47 +1000 Graham Williams"
///
/// Copyright (C) 2025, Togaware Pty Ltd.
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

import 'package:rattle/providers/wordcloud.dart';

/// Map word cloud template patterns in [code] to their current values.

String mapWordCloud(WidgetRef ref, String code) {
  // Obtain the current values of the global variables.

  int maxWord = ref.read(maxWordProvider);
  int textCorFreq = ref.read(textCorFreqProvider);

  bool checkbox = ref.read(checkboxProvider);
  bool lowerCase = ref.read(lowerCaseProvider);
  bool punctuation = ref.read(punctuationProvider);
  bool removeNumbers = ref.read(removeNumbersProvider);
  bool removeSparse = ref.read(removeSparseProvider);
  bool stem = ref.read(stemProvider);
  bool stopword = ref.read(stopwordProvider);
  bool stripWhitespace = ref.read(stripWhitespaceProvider);

  double textCorLimit = ref.read(textCorLimitProvider);
  double textSparseMax = ref.read(sparseMaxProvider);

  String language = ref.read(languageProvider);
  String minFreq = ref.read(minFreqProvider).toString();
  String textCorWord = ref.read(textCorWordProvider);

  // Perform the mapping.

  code = code.replaceAll('<RANDOMORDER>', checkbox.toString().toUpperCase());
  code = code.replaceAll('<TEXT_STEM>', stem ? 'TRUE' : 'FALSE');
  code = code.replaceAll('<TEXT_PUNCTUATION>', punctuation ? 'TRUE' : 'FALSE');
  code = code.replaceAll('<TEXT_STOPWORD>', stopword ? 'TRUE' : 'FALSE');
  code = code.replaceAll('<LANGUAGE>', language);
  code = code.replaceAll('<MINFREQ>', minFreq);
  code = code.replaceAll('<MAXWORD>', maxWord.toString());
  code = code.replaceAll('<TEXT_LOWER_CASE>', lowerCase ? 'TRUE' : 'FALSE');
  code = code.replaceAll(
    '<TEXT_REMOVE_SPARSE>',
    removeSparse ? 'TRUE' : 'FALSE',
  );
  code = code.replaceAll(
    '<TEXT_REMOVE_NUMBERS>',
    removeNumbers ? 'TRUE' : 'FALSE',
  );
  code = code.replaceAll(
    '<TEXT_STRIP_WHITESPACE>',
    stripWhitespace ? 'TRUE' : 'FALSE',
  );
  code = code.replaceAll('<TEXT_SPARSE_MAX>', textSparseMax.toString());
  code = code.replaceAll('<TEXT_COR_WORD>', textCorWord);
  code = code.replaceAll('<TEXT_COR_LIMIT>', textCorLimit.toString());
  code = code.replaceAll('<TEXT_COR_FREQ>', textCorFreq.toString());
  code = code.replaceAll('<MINFREQ>', minFreq);

  return (code);
}
