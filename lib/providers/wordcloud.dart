/// Providers for text mining.
//
// Time-stamp: <Monday 2025-05-12 11:25:41 +1000 Graham Williams>
//
/// Copyright (C) 2025, Togaware Pty Ltd
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
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
// this program.  If not, see <https://www.gnu.org/licenses/>.
///
/// Authors: Zheyuan Xu, Graham Williams

library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/wordcloud.dart';

final checkboxProvider = StateProvider<bool>((ref) => false);
final corpusSaveNameProvider = StateProvider<String>((ref) => '');
final languageProvider = StateProvider<String>(
  (ref) => stopwordLanguages.first,
);
final maxWordProvider = StateProvider<int>((ref) => 500);
final minFreqProvider = StateProvider<int>((ref) => 5);
final punctuationProvider = StateProvider<bool>((ref) => false);
final removeSparseProvider = StateProvider<bool>((ref) => false);
final sparseMaxProvider = StateProvider<double>((ref) => 0.9);
final stopwordProvider = StateProvider<bool>((ref) => false);
final stemProvider = StateProvider<bool>((ref) => false);
final lowerCaseProvider = StateProvider<bool>((ref) => false);
final removeNumbersProvider = StateProvider<bool>((ref) => false);
final stripWhitespaceProvider = StateProvider<bool>((ref) => false);
final textCorWordProvider = StateProvider<String>((ref) => 'the');
final textCorLimitProvider = StateProvider<double>((ref) => 0.7);
final textCorFreqProvider = StateProvider<int>((ref) => 20);
