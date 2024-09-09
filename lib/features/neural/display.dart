/// Widget to display the NEURAL introduction or output.
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Tuesday 2024-09-10 05:47:51 +1000 Graham Williams>
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
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/r/extract.dart';
import 'package:rattle/widgets/image_page.dart';
import 'package:rattle/widgets/pages.dart';
import 'package:rattle/widgets/show_markdown_file.dart';
import 'package:rattle/widgets/text_page.dart';
import 'package:rattle/utils/image_exists.dart';

/// The panel displays the instructions or the output.

class NeuralDisplay extends ConsumerStatefulWidget {
  const NeuralDisplay({super.key});

  @override
  ConsumerState<NeuralDisplay> createState() => _NeuralDisplayState();
}

class _NeuralDisplayState extends ConsumerState<NeuralDisplay> {
  @override
  Widget build(BuildContext context) {
    String stdout = ref.watch(stdoutProvider);
    String content = '';

    List<Widget> pages = [
      showMarkdownFile(neuralIntroFile, context),
    ];

    content = rExtract(stdout, 'print(model_nn)');

    if (content.isNotEmpty) {
      pages.add(
        TextPage(
          title: '# Neural Net Model\n\n'
              'Built using `nnet()`.\n\n',
          content: '\n$content',
        ),
      );
    }

    content = rExtract(stdout, 'summary(model_nn)');

    if (content.isNotEmpty) {
      pages.add(
        TextPage(
          title: '# Neural Net Model\n\n'
              'Built using `nnet()`.\n\n',
          content: '\n$content',
        ),
      );
    }

    String image = '$tempDir/model_nn_nnet.svg';

    if (imageExists(image)) {
      pages.add(
        ImagePage(
          title: 'NNET',
          path: image,
        ),
      );
    }

    return Pages(children: pages);
  }
}
