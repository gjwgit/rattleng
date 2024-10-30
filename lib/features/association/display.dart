/// Widget to display the ASSOCIATION introduction or output.
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Thursday 2024-09-26 08:29:59 +1000 Graham Williams>
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
/// Authors: Graham Williams, Zheyuan Xu

library;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/markdown.dart';
import 'package:rattle/constants/temp_dir.dart';
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/r/extract_association.dart';
import 'package:rattle/utils/image_exists.dart';
import 'package:rattle/utils/show_markdown_file.dart';
import 'package:rattle/widgets/image_page.dart';
import 'package:rattle/widgets/page_viewer.dart';
import 'package:rattle/widgets/text_page.dart';

/// The panel displays the instructions or the output.

class AssociationDisplay extends ConsumerStatefulWidget {
  const AssociationDisplay({super.key});

  @override
  ConsumerState<AssociationDisplay> createState() => _AssociationDisplayState();
}

class _AssociationDisplayState extends ConsumerState<AssociationDisplay> {
  @override
  Widget build(BuildContext context) {
    String stdout = ref.watch(stdoutProvider);

    final pageController = ref.watch(
      associationControllerProvider,
    );

    List<Widget> pages = [showMarkdownFile(associationIntroFile, context)];
    String content = '';

    content = rExtractAssociation(stdout);

    if (content.isNotEmpty) {
      pages.add(
        TextPage(
          title: '# Association Rules\n\n'
              'Built using `apriori()`.\n\n',
          content: '\n$content',
        ),
      );
    }

    String plotImage = '$tempDir/model_arules_item_plot.png';

    if (imageExists(plotImage)) {
      pages.add(
        ImagePage(
          title: 'ASSOCIATION RULES',
          path: plotImage,
          svgImage: false,
        ),
      );
    }

    String frequencyImage = '$tempDir/model_arules_item_frequency.svg';

    if (imageExists(frequencyImage)) {
      pages.add(
        ImagePage(
          title: 'ASSOCIATION FREQUENCY',
          path: frequencyImage,
        ),
      );
    }

    return PageViewer(
      pageController: pageController,
      pages: pages,
    );
  }
}
