/// Wordcloud specific constants for Rattle
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
//
// Time-stamp: <Sunday 2025-08-10 17:27:25 +1000 Graham Williams>
//
// Licensed under the GNU General Public License, Version 3 (the "License");
///
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
/// Authors: Graham Williams

library;

import 'package:rattle/constants/temp_dir.dart';

/// Location of the markdown file containing the word cloud welcome message.

const String wordCloudMsgFile = 'assets/markdown/wordcloud.md';

String wordCloudImagePath = '$tempDir/wordcloud.svg';
String tmpImagePath = '$tempDir/tmp.png';

const List<String> stopwordLanguages = <String>[
  'english',
  'SMART',
  'catalan',
  'romanian',
  'danish',
  'dutch',
  'finnish',
  'french',
  'german',
  'hungarian',
  'italian',
  'norwegian',
  'portuguese',
  'russian',
  'spanish',
  'swedish',
];
