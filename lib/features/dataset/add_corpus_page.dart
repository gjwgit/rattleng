/// Add a Corpus Page to the pages.
///
// Time-stamp: "Friday 2025-09-12 20:56:56 +1000 Graham Williams"
///
/// Copyright (C) 2025, Togaware Pty Ltd
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
// this program.  If not, see https://opensource.org/license/gpl-3-0.
///
/// Authors: Graham Williams

library;

import 'package:flutter/material.dart';

import 'package:rattle/r/extract.dart';
import 'package:rattle/widgets/text_page.dart';

// Add a page for corpus content.

void addCorpusPage(String stdout, List<Widget> pages) {
  String docs = rExtract(stdout, '> docs');
  String inspect = rExtract(stdout, '> tm::inspect(dtm)');
  String docinfo = rExtract(stdout, '> for (i in 1:length(docs)) {');
  String content = '## Summary of the Docs\n\n$docs\n\n'
      '## Summary of the Document Term Matrix\n\n$inspect\n\n'
      '## Individual Documents\n\n$docinfo\n\n';

  if (docs.isNotEmpty || inspect.isNotEmpty || docinfo.isNotEmpty) {
    pages.add(
      TextPage(
        title: '''

        # Corpus Content

        Built using [tm::inspect()](https://www.rdocumentation.org/packages/tm/topics/Corpus).

        ''',
        content: content,
      ),
    );
  }
}
