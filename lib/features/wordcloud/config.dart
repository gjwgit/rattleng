/// The WordCloud configuration panel.
//
// Time-stamp: <Friday 2024-12-20 16:01:13 +1100 Graham Williams>
//
/// Copyright (C) 2024, Togaware Pty Ltd
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
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
/// Authors: Yixiang Yin, Graham Williams

library;

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';

import 'package:rattle/constants/spacing.dart';
import 'package:rattle/constants/wordcloud.dart';
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/providers/wordcloud/checkbox.dart';
import 'package:rattle/providers/wordcloud/build.dart';
import 'package:rattle/providers/wordcloud/language.dart';
import 'package:rattle/providers/wordcloud/maxword.dart';
import 'package:rattle/providers/wordcloud/minfreq.dart';
import 'package:rattle/providers/wordcloud/punctuation.dart';
import 'package:rattle/providers/wordcloud/stem.dart';
import 'package:rattle/providers/wordcloud/stopword.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/utils/timestamp.dart';
import 'package:rattle/widgets/activity_button.dart';
import 'package:rattle/widgets/labelled_checkbox.dart';

class WordCloudConfig extends ConsumerStatefulWidget {
  const WordCloudConfig({super.key});

  @override
  ConsumerState<WordCloudConfig> createState() => _ConfigState();
}

class _ConfigState extends ConsumerState<WordCloudConfig> {
  final maxWordTextController = TextEditingController();
  final minFreqTextController = TextEditingController();

  String dropdownValue = stopwordLanguages.first;

  @override
  void initState() {
    super.initState();
    maxWordTextController.addListener(_updateMaxWordProvider);
    minFreqTextController.addListener(_updateMinFreqProvider);
  }

  @override
  void dispose() {
    maxWordTextController.dispose();
    minFreqTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Keep the value of text field.

    maxWordTextController.text = ref.read(maxWordProvider);
    minFreqTextController.text = ref.read(minFreqProvider).toString();

    // Layout the config bar.

    return Column(
      spacing: configRowSpace,
      children: [
        configTopGap,

        Row(
          spacing: configWidgetSpace,
          children: [
            configLeftGap,
            ActivityButton(
              pageControllerProvider:
                  wordcloudPageControllerProvider, // Optional navigation

              onPressed: () {
                // Clean up the files from previous use.

                // TODO 20240612 gjw REVIEW HOW CLEANUP IS DONE.
                //
                // Is this required here? Or cleanup when exit the app? Or rely
                // on os to cleanup /tmp?

                File oldWordcloudFile = File(wordCloudImagePath);
                if (oldWordcloudFile.existsSync()) {
                  oldWordcloudFile.deleteSync();
                }

                File oldTmpFile = File(tmpImagePath);
                if (oldTmpFile.existsSync()) {
                  oldTmpFile.deleteSync();
                }

                // The main action here is to run the R script to build the word
                // cloud itself whic is saved into an SVG file.

                rSource(context, ref, ['model_build_word_cloud']);

                // Toggle the state to trigger rebuild.

                ref.read(wordCloudBuildProvider.notifier).state = timestamp();
              },
              child: const Text('Display Word Cloud'),
            ),
          ],
        ),

        // Options for the current functionality.

        Row(
          spacing: configWidgetSpace,
          children: [
            configBotGap,
            const Text('Tuning Options:  '),
            // Checkbox for random order of words in the cloud.

            LabelledCheckbox(
              key: const Key('random_order'),
              tooltip: '''

               Plot words in random order, otherwise in decreasing frequency.

              ''',
              label: 'Random Order',
              provider: checkboxProvider,
            ),

            LabelledCheckbox(
              key: const Key('stem'),
              tooltip: '''

                Stemming reduces words to their base or root form.  Two
                different words, when stemmed, can become the same and so can
                reduce unnecessary clutter in the wordcloud.

              ''',
              label: 'Stem',
              provider: stemProvider,
            ),

            LabelledCheckbox(
              key: const Key('remove_punctuation'),
              tooltip: '''

                Remove punctuation marks such as periods.

              ''',
              label: 'Remove Punctuation',
              provider: punctuationProvider,
            ),

            LabelledCheckbox(
              key: const Key('remove_stopwords'),
              tooltip: '''

                Remove common language words for the wordcloud.

              ''',
              label: 'Remove Stopwords',
              provider: stopwordProvider,
            ),

            Expanded(
              child: MarkdownTooltip(
                message: '''

                Select the language to filter out common stopwords from the word
                cloud.  'SMART' covers English stopwords from the SMART
                information retrieval system (as documented in Appendix 11 of
                https://jmlr.csail.mit.edu/papers/volume5/lewis04a/)

                ''',
                child: DropdownMenu<String>(
                  label: const Text('Language'),
                  leadingIcon: const Icon(Icons.language),
                  initialSelection: stopwordLanguages.first,
                  dropdownMenuEntries: stopwordLanguages.map((s) {
                    return DropdownMenuEntry(value: s, label: s);
                  }).toList(),
                  onSelected: (String? value) {
                    ref.read(languageProvider.notifier).state = value!;
                  },
                ),
              ),
            ),
          ],
        ),

        // Parameters for the current functionality.

        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            spacing: configWidgetSpace,
            children: [
              configBotGap,
              const Text('Tuning Parameters:  '),
              // max word text field
              SizedBox(
                width: 150.0,
                child: MarkdownTooltip(
                  message: '''

                  Maximum number of words plotted.  Drop least frequent words.

                  ''',
                  child: TextField(
                    controller: maxWordTextController,
                    style: const TextStyle(fontSize: 16),
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Max Words',
                      labelStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 150.0,
                child: MarkdownTooltip(
                  message: '''

                  Filter out less frequent words.  If this results in all words
                  being filtered out the threshold will not be used.

                      ''',
                  child: TextField(
                    controller: minFreqTextController,
                    style: const TextStyle(fontSize: 16),
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Min Freq',
                      labelStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String sanitiseMaxWord(String txt) {
    // It should be int or Inf. Otherwise, convert to an Inf.

    return (txt == 'Inf' || int.tryParse(txt) != null) ? txt : 'Inf';
  }

  void _updateMaxWordProvider() {
    ref.read(maxWordProvider.notifier).state =
        sanitiseMaxWord(maxWordTextController.text);
  }

  void _updateMinFreqProvider() {
    ref.read(minFreqProvider.notifier).state =
        int.tryParse(minFreqTextController.text) ?? 1;
  }
}
