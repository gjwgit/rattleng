/// Widget to display the Tree introduction or built tree.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Sunday 2024-06-30 12:37:32 +1000 Graham Williams>
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

import 'package:rattle/constants/markdown.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/r/extract.dart';
import 'package:rattle/r/extract_tree.dart';
import 'package:rattle/widgets/pages.dart';
import 'package:rattle/widgets/show_markdown_file.dart';
import 'package:rattle/widgets/text_page.dart';

/// The TREE panel displays the tree instructions and then build output.

class TreeDisplay extends ConsumerStatefulWidget {
  const TreeDisplay({super.key});

  @override
  ConsumerState<TreeDisplay> createState() => TreeDisplayState();
}

class TreeDisplayState extends ConsumerState<TreeDisplay> {
  @override
  Widget build(BuildContext context) {
    String stdout = ref.watch(stdoutProvider);

    List<Widget> pages = [showMarkdownFile(treeIntroFile, context)];

    String content = '';

    ////////////////////////////////////////////////////////////////////////
    // DEFAULT TREE TEXT
    ////////////////////////////////////////////////////////////////////////

    content = rExtractTree(stdout);

    if (content.isNotEmpty) {
      pages.add(
        TextPage(
          title: '# Decision Tree Model\n\n'
              'Built using `rpart()`.\n\n',
          content: '\n$content',
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////
    // CONVERT TO RULES
    ////////////////////////////////////////////////////////////////////////

    content = rExtract(stdout, 'asRules(model_rpart)');

    if (content.isNotEmpty) {
      pages.add(
        TextPage(
          title: '# Decision Tree as Rules\n\n'
              'Built using `rattle::asRules()`.\n\n',
          content: '\n$content',
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////

    return Pages(children: pages);
  }
}
