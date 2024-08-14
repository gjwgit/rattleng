/// Widget to display the SUMMARY introduction and display output.
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Tuesday 2024-08-06 13:40:21 +1000 Graham Williams>
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
import 'package:rattle/providers/summary_page_count.dart';
import 'package:rattle/r/extract.dart';
import 'package:rattle/r/extract_summary.dart';
import 'package:rattle/widgets/pages.dart';
import 'package:rattle/widgets/show_markdown_file.dart';
import 'package:rattle/widgets/text_page.dart';

/// The panel displays the instructions or the R output.

class SummaryDisplay extends ConsumerStatefulWidget {
  const SummaryDisplay({super.key});

  @override
  ConsumerState<SummaryDisplay> createState() => _SummaryDisplayState();
}

class _SummaryDisplayState extends ConsumerState<SummaryDisplay> {
  //

  @override
  Widget build(BuildContext context) {
    String stdout = ref.watch(stdoutProvider);

    List<Widget> pages = [showMarkdownFile(summaryIntroFile, context)];

    String content = '';
    List<String> lines = [];

    ////////////////////////////////////////////////////////////////////////
    // BASIC R SUMMARY
    ////////////////////////////////////////////////////////////////////////

    content = rExtractSummary(stdout);

    // Add a blank line between each sub-table.

    lines = content.split('\n');

    for (int i = 0; i < lines.length; i++) {
      if (lines[i].startsWith('  ') && !lines[i].trimLeft().startsWith('NA')) {
        lines[i] = '\n${lines[i]}';
      }
    }

    content = lines.join('\n');

    // Replace multiple empty lines with a single empty line.

    content = content.replaceAll(RegExp(r'\n\s*\n\s*\n+'), '\n\n');

    if (content.isNotEmpty) {
      pages.add(
        TextPage(
          title: '''

          # Summary of the Dataset
          
          Generated using
          [base::summary(ds)](https://www.rdocumentation.org/packages/base/topics/summary).
          
          This is the most basic R command for summarising the dataset.
          
          For **numeric data** the minimum, and maximum values are listed.
          Between these we can see listed the first and third quartiles as well
          as the median (the second quartile) and the mean.
          
          For **categoric data** a frequency table is provided, showing the
          frequency of the categoric values from the most frequent to the least
          frequent.  Only the top few categoric values will be listed.
          
          A count of **missing values** is shown for variables with 
          missing values.

          ''',
          content: content,
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////
    // HMISC CONTENTS
    ////////////////////////////////////////////////////////////////////////

    content = rExtract(stdout, 'contents(ds)');

    // Replace multiple empty lines with a single empty line.

    content = content.replaceAll(RegExp(r'\n\s*\n\s*\n+'), '\n\n');

    if (content.isNotEmpty) {
      pages.add(
        TextPage(
          title: '# Contents of the Dataset\n\n'
              'Generated using [Hmisc::contents(ds)]'
              '(https://hbiostat.org/r/hmisc/).\n\n'
              'This content-oriented summary of the data lists the number of '
              '**levels** (the different values for the categoric variable) '
              'for each categoric variable, as well as identifying '
              'whether it is ordered. The type of storage is reported '
              'together with a count of the number of **missing values** (NAs).'
              '\n\n'
              'The actual levels for categoric variables are listed in the '
              'table shown further down in the display',
          content: content,
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////
    // HMISC DESCRIBE
    ////////////////////////////////////////////////////////////////////////

    content = rExtract(stdout, 'describe(ds)');

    // Remove the initial `ds` and separate each variable with a blank line.

    lines = content.split('\n');

    // Filter out the lines that are exactly 'ds'.

    lines = lines.where((line) => line.trim() != 'ds').toList();

    // Add extra line after each variable block.

    for (int i = 0; i < lines.length; i++) {
      if (lines[i].startsWith('--')) {
        lines[i] = '\n${lines[i]}\n';
      }
    }

    // Insert a bank line before the listing of the percentiles.

    for (int i = 0; i < lines.length; i++) {
      if (lines[i].startsWith('     .')) {
        lines[i] = '\n${lines[i]}';
      }
    }

    // Join the lines back into a single string.

    content = lines.join('\n');

    if (content.isNotEmpty) {
      pages.add(
        TextPage(
          title: '# Describe the Dataset\n\n'
              'Generated using [Hmisc::describe(ds)]'
              '(https://hbiostat.org/r/hmisc/)',
          content: content,
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////
    // KURTOSIS AND SKEWNESS
    ////////////////////////////////////////////////////////////////////////

    content = 'Kurtosis:\n';
    content += rExtract(stdout, 'timeDate::kurtosis(ds[numc], na.rm=TRUE)');
    content += '\nSkewness:\n';
    content += rExtract(stdout, 'timeDate::skewness(ds[numc], na.rm=TRUE)');

    // Regular expression to match lines like '[1] "xxxx"'

    final pattern = RegExp(r'^\[1\] "(.*)"$', multiLine: true);

    // Replace matched lines with 'calculated using method="xxxx"'

    content = content.replaceAllMapped(pattern, (match) {
      String method = match.group(1) ?? '';

      return 'Calculated using method="$method"';
    });

    // Iterate over the lines and modify them.

    // Split the string into lines.

    lines = content.split('\n');

    // Filter out lines that match 'attr(,"method")'

    lines = lines.where((line) => line.trim() != 'attr(,"method")').toList();

    // Iterate over the lines and modify them.

    for (int i = 0; i < lines.length; i++) {
      // Add some spacing to the output.

      if (!RegExp(r'^\s*[\d-]').hasMatch(lines[i])) {
        lines[i] = '\n${lines[i]}';
      }
    }

    // Join the lines back into a single string.

    content = lines.join('\n');

    if (lines.length > 4) {
      pages.add(
        TextPage(
          title: '''

          # Kurtosis and Skewness

          Generated using
          [timeDate::kurtosis(ds)](https://www.rdocumentation.org/packages/timeDate/topics/kurtosis)
          and
          [timeDate::skewness(ds)](https://www.rdocumentation.org/packages/timeDate/topics/skewness).

          ''',
          content: '\n$content',
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////
    // FBASICS STATS
    ////////////////////////////////////////////////////////////////////////

    content = rExtract(stdout, 'lapply(ds[numc], fBasics::basicStats)');

    // Replace $ at the beginning of any lines.

    //content = content.replaceAll(RegExp(r'^$'), '');
    content = content.replaceAll('\$', '');

    if (content.isNotEmpty) {
      pages.add(
        TextPage(
          title: '# Detailed Variable Statistics\n\n'
              'Generated using [fBasics::basicStats(ds)]'
              '(https://www.rdocumentation.org/packages/fBasics/topics/BasicStatistics).\n\n',
          content: '\n$content',
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////
    // CROSSTAB<
    ////////////////////////////////////////////////////////////////////////

    content = rExtract(stdout, 'descr::CrossTable(ds');

    // Remove any line beginning with +.

    lines = content.split('\n');

    // Iterate over the lines and modify them.

    // Remove lines starting with '+'

    lines = lines.where((line) => !line.trimLeft().startsWith('+')).toList();

    // Join the lines back into a single string.

    content = lines.join('\n');

    if (content.isNotEmpty) {
      pages.add(
        TextPage(
          title: '''

          # Cross Tabulation

          Generated using
          [descr::CrossTable(ds)](https://www.rdocumentation.org/packages/descr/topics/CrossTable)

              ''',
          content: '\n$content',
        ),
      );
    }

    // Schedule the state update after the widget has been built.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(summaryPageCountProvider.notifier).state = pages.length;
    });

    ////////////////////////////////////////////////////////////////////////

    return Pages(children: pages);
  }
}
