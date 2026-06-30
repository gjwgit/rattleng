/// The WordCloud configuration panel tooltips.
//
// Time-stamp: "Friday 2026-03-06 13:46:40 +1100 Graham Williams"
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

// TODO 20260306 gjw Migrating tooltips here from config.dart.

const textMineToolTip = '''

**Text Mine**

Tap here to build the analysis of the text document(s).

''';

const randomOrderToolTip = '''

**Random Order**

Tick the checkbox to have the word cloud generated with a
random ordering of the words.  Otherwise (the default) the most frequent words
are centered and then other words are drawn in decreasing frequency as we
progress to the edg of the picture.

''';

const saveCsvToolTip = '''

**Save to CSV**

Tap here to save the generated document term matrix to a CSV
file, one row for each document and a column for each term.

''';

const stemToolTip = '''

**Stem**

Enable this to reduces words to their base or root form.  Two
different words, when stemmed, can become the same and so can reduce unnecessary
clutter in the wordcloud.

''';

const punctuationToolTip = '''

**Punctuation**

Extraneous data can be removed including various punctuation.

''';

const stopwordsToolTip = '''

**Stopwords**

Remove common language words. The words removed depend on the
chosen language.

''';

const languageToolTip = '''

**Language**

The stopwords removed will depend on the language. Select the
language of choice here to filter out common stopwords.

The stopwords come from
[tm::stopwords()](https://rdrr.io/rforge/tm/man/stopwords.html).

For English, 'SMART' will remove some 570 stopwords, more than the `english`
option which removes only 170 stopwords.

''';
