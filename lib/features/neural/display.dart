/// Widget to display the NEURAL introduction or output.
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Saturday 2024-09-21 10:14:52 +1000 Graham Williams>
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
import 'package:rattle/constants/temp_dir.dart';
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/r/extract.dart';
import 'package:rattle/utils/image_exists.dart';
import 'package:rattle/utils/word_wrap.dart';
import 'package:rattle/widgets/image_page.dart';
import 'package:rattle/widgets/page_viewer.dart';
import 'package:rattle/widgets/show_markdown_file.dart';
import 'package:rattle/widgets/text_page.dart';

/// The panel displays the instructions or the output.

class NeuralDisplay extends ConsumerStatefulWidget {
  const NeuralDisplay({super.key});

  @override
  ConsumerState<NeuralDisplay> createState() => _NeuralDisplayState();
}

class _NeuralDisplayState extends ConsumerState<NeuralDisplay> {
  @override
  Widget build(BuildContext context) {
    final pageController = ref.watch(
        neuralPageControllerProvider); // Get the PageController from Riverpod

    String stdout = ref.watch(stdoutProvider);
    String content = '';

    List<Widget> pages = [
      showMarkdownFile(neuralIntroFile, context),
    ];

    ////////////////////////////////////////////////////////////////////////

    content = rExtract(stdout, 'print(model_nn)');

    if (content.isNotEmpty) {
      // Capitalise each line and for the Input: line, wordwrap and comma
      // separate the column names.

      List<String> lines = content.split('\n');

      lines = lines.map((line) {
        if (line.isEmpty) return line;

        // Comma separate the variable names.

        if (line.startsWith('inputs: ')) {
          String tail = line.substring(8);
          tail = tail.replaceAll(r' ', ', ');
          line = 'inputs: $tail';
        }

        // Capitalise the first letter of the line.

        String result = line[0].toUpperCase();
        result += line.substring(1).trim();
        result += '.';

        // Special case for the first line where the space after the 'A' seems
        // to have got lost.

        if (result.startsWith('A')) {
          result = 'A ${result.substring(1)}';
        }

        return wordWrap(result);
      }).toList();

      content = lines.join('\n\n');

      String weights = rExtract(stdout, 'summary(model_nn)');

      // Remove the repeated first two lines.

      lines = weights.split('\n');
      if (lines.length > 2) {
        lines = lines.sublist(2);
      } else {
        lines = [];
      }

      // If the line starts with ' +b' then insert an empty line.

      List<String> newLines = [];
      for (String line in lines) {
        if (line.startsWith(RegExp(' +b'))) newLines.add('');
        newLines.add(line);
      }

      weights = newLines.join('\n');

      content = '''$content

$weights

    ''';

      pages.add(
        TextPage(
          title: '''

          # Neural Net Model - Summary and Weights

          Visit the [Survival
          Guide](https://survivor.togaware.com/datascience/neural-networks.html). Built
          using
          [nnet::nnet()](https://www.rdocumentation.org/packages/nnet/topics/nnet).

            ''',
          content: '\n$content',
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////

    String image = '$tempDir/model_nn_nnet.svg';

    if (imageExists(image)) {
      pages.add(
        ImagePage(
          title: '''

          # Neural Net Model - Visual

          Visit
          [NeuralNetTools::plotnet()](https://www.rdocumentation.org/packages/NeuralNetTools/topics/plotnet).

          ''',
          path: image,
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////

    return PageViewer(
      pageController: pageController,
      pages: pages,
    );
  }
}
