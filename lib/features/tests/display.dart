/// Widget to display the TESTS introduction or output.
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Tuesday 2024-07-30 14:58:01 +1000 Graham Williams>
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
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/r/extract.dart';
import 'package:rattle/widgets/page_viewer.dart';
import 'package:rattle/widgets/show_markdown_file.dart';
import 'package:rattle/widgets/text_page.dart';

/// The panel displays the instructions or the output.

class TestsDisplay extends ConsumerStatefulWidget {
  const TestsDisplay({super.key});

  @override
  ConsumerState<TestsDisplay> createState() => _TestsDisplayState();
}

class _TestsDisplayState extends ConsumerState<TestsDisplay> {
  //

  @override
  Widget build(BuildContext context) {
    final pageController = ref.watch(
        testsPageControllerProvider); // Get the PageController from Riverpod

    String stdout = ref.watch(stdoutProvider);

    List<Widget> pages = [showMarkdownFile(testsIntroFile, context)];

    String content = '';

    ////////////////////////////////////////////////////////////////////////
    // CORRELATION
    ////////////////////////////////////////////////////////////////////////

    content = rExtract(stdout, '> fBasics::correlationTest(');

    if (content.isNotEmpty) {
      pages.add(
        TextPage(
          title: '''

          # Pearson Correlation Test

          Visit the [Survival
          Guide](https://survivor.togaware.com/datascience/correlation-test.html)
          and
          [fBasics::correlationTest()](https://www.rdocumentation.org/packages/fBasics/topics/correlationTest)

            ''',
          content: content,
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////
    // KOLMOGOROV-SMIRNOV TWO SAMPLE TEST
    ////////////////////////////////////////////////////////////////////////

    content = rExtract(stdout, '> fBasics::ks2Test(');

    if (content.isNotEmpty) {
      pages.add(
        TextPage(
          title: '''

          # Kolmogorov-Smirnov Two Sample Test

          Visit the [Survival
          Guide](https://survivor.togaware.com/datascience/kolmogorov-smirnov-test.html)
          and
          [fBasics::ks2Test()](https://www.rdocumentation.org/packages/fBasics/topics/ks2Test)

            ''',
          content: content,
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////
    // WILCOX
    ////////////////////////////////////////////////////////////////////////

    content = rExtract(stdout, '> wilcox.test(');

    if (content.isNotEmpty) {
      pages.add(
        TextPage(
          title: '''

          # Wilcoxon Rank Sum Test

          Visit the [Survival Guide](https://survivor.togaware.com/datascience/wilcoxon-rank-sum-test.html) and
          [stats::wilcoxon.test()](https://www.rdocumentation.org/packages/stats/topics/wilcox.test)

            ''',
          content: content,
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////
    // CORRELATION
    ////////////////////////////////////////////////////////////////////////

    content = rExtract(stdout, '> fBasics::locationTest(');

    if (content.isNotEmpty) {
      pages.add(
        TextPage(
          title: '''

          # t-Test Two Sample Location Test

          Visit the [Survival Guide](https://survivor.togaware.com/datascience/t-test-two-sample.html) and
          [fBasics::locationTest()](https://www.rdocumentation.org/packages/fBasics/topics/locationTest)

            ''',
          content: content,
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////
    // CORRELATION
    ////////////////////////////////////////////////////////////////////////

    content = rExtract(stdout, '> fBascis::varianceTest');

    if (content.isNotEmpty) {
      pages.add(
        TextPage(
          title: '''

          # Two Sample Variance Test

          Visit the [Survival
          Guide](https://survivor.togaware.com/datascience/f-test-two-sample.html)
          and
          [fBasics::varianceTest()](https://www.rdocumentation.org/packages/fBasics/topics/varianceTest)

            ''',
          content: content,
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
