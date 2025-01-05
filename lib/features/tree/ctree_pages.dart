/// Return a list of pages for the ctree tree display.
///
/// Copyright (C) 2023-2025, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Sunday 2025-01-05 19:08:54 +1100 Graham Williams>
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
/// Authors: Graham Williams

library;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/temp_dir.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/r/extract.dart';
import 'package:rattle/utils/image_exists.dart';
import 'package:rattle/widgets/image_page.dart';
import 'package:rattle/widgets/text_page.dart';

/// Ctree tree displays.

List<Widget> ctreePages(
  WidgetRef ref,
) {
  String stdout = ref.watch(stdoutProvider);

  // Begin the list of pages to display with the introduction markdown text.

  List<Widget> pages = [];

  // Temporary storage for page content or image.

  String content = '';
  String image = '';

  ////////////////////////////////////////////////////////////////////////

  // Default tree text.

  content = rExtract(stdout, 'print(model_ctree)');

  if (content.isNotEmpty) {
    pages.add(
      TextPage(
        title: '''

        # Decision Tree Model

        Built using [party::ctree()](https://www.rdocumentation.org/packages/party/topics/ctree).

        ''',
        content: '\n$content',
      ),
    );
  }

  ////////////////////////////////////////////////////////////////////////

  // Tree visualisation.

  image = '$tempDir/model_tree_ctree.svg';

  if (imageExists(image)) {
    pages.add(
      ImagePage(
        title: '''

        # Decision Tree Visualisation

        Built using
        [partykit::print.party()](https://www.rdocumentation.org/packages/partykit/topics/print.party).

        ''',
        path: image,
      ),
    );
  }

  ////////////////////////////////////////////////////////////////////////

  return pages;
}
