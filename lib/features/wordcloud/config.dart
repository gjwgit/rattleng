/// The WordCloud configuration panel.
//
// Time-stamp: <Thursday 2025-05-08 16:29:38 +1000 Graham Williams>
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
/// Authors: Yixiang Yin, Graham Williams, Zheyuan Xu

library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';

import 'package:rattle/constants/spacing.dart';
import 'package:rattle/constants/style.dart';
import 'package:rattle/constants/wordcloud.dart';
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/providers/wordcloud.dart';
import 'package:rattle/providers/wordcloud/build.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/utils/build_text_field.dart';
import 'package:rattle/utils/timestamp.dart';
import 'package:rattle/widgets/activity_button.dart';
import 'package:rattle/widgets/labelled_checkbox.dart';
import 'package:rattle/widgets/number_field.dart';

class WordCloudConfig extends ConsumerStatefulWidget {
  const WordCloudConfig({super.key});

  @override
  ConsumerState<WordCloudConfig> createState() => _ConfigState();
}

class _ConfigState extends ConsumerState<WordCloudConfig> {
  final maxWordTextController = TextEditingController();
  final minFreqTextController = TextEditingController();
  final sparseTextController = TextEditingController();
  final textCorWordController = TextEditingController();
  final textCorLimitController = TextEditingController();
  final textCorFreqController = TextEditingController();
  final textMinCountsController = TextEditingController();
  String dropdownValue = stopwordLanguages.first;

  @override
  void initState() {
    super.initState();
    maxWordTextController.addListener(_updateMaxWordProvider);
    minFreqTextController.addListener(_updateMinFreqProvider);
    sparseTextController.addListener(_updateSparseProvider);
    textCorWordController.addListener(_updateTextCorWordProvider);
    textCorLimitController.addListener(_updateTextCorLimitProvider);
    textCorFreqController.addListener(_updateTextCorFreqProvider);
  }

  @override
  void dispose() {
    maxWordTextController.dispose();
    minFreqTextController.dispose();
    sparseTextController.dispose();
    textCorWordController.dispose();
    textCorLimitController.dispose();
    textCorFreqController.dispose();
    textMinCountsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Keep the value of text field.

    maxWordTextController.text = ref.read(maxWordProvider).toString();
    minFreqTextController.text = ref.read(minFreqProvider).toString();
    sparseTextController.text = ref.read(sparseMaxProvider).toString();
    textCorWordController.text = ref.read(textCorWordProvider).toString();
    textCorLimitController.text = ref.read(textCorLimitProvider).toString();
    textCorFreqController.text = ref.read(textCorFreqProvider).toString();

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

                rSource(context, ref, ['model_build_wordcloud']);

                // Toggle the state to trigger rebuild.

                ref.read(wordCloudBuildProvider.notifier).state = timestamp();
              },
              tooltip: '''

              **Text Mine:** Tap here to build the analysis of the text
                document(s).

              ''',
              child: const Text('Text Mine'),
            ),

            // Checkbox for random order of words in the cloud.

            LabelledCheckbox(
              key: const Key('random_order'),
              tooltip: '''

               **Random Order:** Tick the checkbox to have the word cloud
               generated with a random ordering of the words.  Otherwise (the
               default) the most frequent words are centered and then other
               words are drawn in decreasing frequency as we progress to the edg
               of the picture.

              ''',
              label: 'Random Order',
              provider: checkboxProvider,
            ),
          ],
        ),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            configRowGap,
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text('Data Cleaning Options:'),
            ),
            configRowGap,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Options for the current functionality.

                  Row(
                    spacing: configWidgetSpace,
                    children: [
                      configBotGap,
                      LabelledCheckbox(
                        key: const Key('text_stem'),
                        tooltip: '''

                        **Stem:**. Enable this to reduces words to their base or
                        root form.  Two different words, when stemmed, can
                        become the same and so can reduce unnecessary clutter in
                        the wordcloud.

                        ''',
                        label: 'Stem',
                        provider: stemProvider,
                      ),
                      LabelledCheckbox(
                        key: const Key('text_remove_punctuation'),
                        tooltip: '''

                        **Punctuation:** Extraneous data can be removed
                          including various punctuation.

                        ''',
                        label: 'Punctuation',
                        provider: punctuationProvider,
                      ),
                      LabelledCheckbox(
                        key: const Key('text_remove_stopwords'),
                        tooltip: '''

                        **Stopwords:** Remove common language words. The words
                        removed depend on the chosen language.

                        ''',
                        label: 'Stopwords',
                        provider: stopwordProvider,
                      ),
                      Expanded(
                        child: MarkdownTooltip(
                          message: '''

                          **Language:** The stopwords removed will depend on the
                          language. Select the language of choice here to filter
                          out common stopwords.

                          The stopwords come from
                          [tm::stopwords()](https://rdrr.io/rforge/tm/man/stopwords.html).

                          For English, 'SMART' will remove some 570 stopwords,
                          more than the `english` option which removes only 170
                          stopwords.

                          ''',
                          child: DropdownMenu<String>(
                            label: const Text('Language'),
                            leadingIcon: const Icon(Icons.language),
                            initialSelection: stopwordLanguages.first,
                            dropdownMenuEntries: stopwordLanguages.map((s) {
                              return DropdownMenuEntry(value: s, label: s);
                            }).toList(),
                            onSelected: (String? value) {
                              ref.read(languageProvider.notifier).state =
                                  value!;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  panelGap,

                  Row(
                    spacing: configWidgetSpace,
                    children: [
                      configBotGap,
                      LabelledCheckbox(
                        key: const Key('lower_case'),
                        tooltip: '''

                        **Lower Case:** Convert all words to lower case.

                        ''',
                        label: 'Lower Case',
                        provider: lowerCaseProvider,
                      ),
                      LabelledCheckbox(
                        key: const Key('remove_numbers'),
                        tooltip: '''

                        **Numbers:** Remove numbers from the text.

                        ''',
                        label: 'Numbers',
                        provider: removeNumbersProvider,
                      ),
                      LabelledCheckbox(
                        key: const Key('strip_whitespace'),
                        tooltip: '''

                        **Whitespace:** Remove whitespace from the text.

                        ''',
                        label: 'Whitespace',
                        provider: stripWhitespaceProvider,
                      ),
                      LabelledCheckbox(
                        key: const Key('remove_sparse'),
                        tooltip: '''

                        **Sparse:** Remove sparse terms from the text. The maximum level
                          of sparseness can be set.

                        ''',
                        label: 'Sparse',
                        provider: removeSparseProvider,
                      ),
                      NumberField(
                        label: 'Sparse:',
                        key: const Key('sparse'),
                        tooltip: '''

                        **Sparse:** The maximum allowed sparsity. Terms are
                        removed if they have a sparsity factor greater than
                        specified here. 0 suggests no sparsity and 1 is complete
                        sparsity.

                        ''',
                        controller: sparseTextController,
                        inputFormatter: FilteringTextInputFormatter.allow(
                          RegExp(r'^[0-9]*\.?[0-9]{0,4}$'),
                        ),
                        interval: 0.01,
                        decimalPlaces: 2,
                        validator: (value) => validateDecimal(value),
                        stateProvider: sparseMaxProvider,
                        enabled: ref.watch(removeSparseProvider),
                        min: 0.0,
                        max: 1.0,
                      ),
                    ],
                  ),
                ],
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
              NumberField(
                label: 'Max Words',
                key: const Key('maxWords'),
                tooltip: '''

                **Max Words:** Specify here the maximum number of words to
                  consider for various analyses. For example, this will be the
                  maximum number of words in the word cloud.

                ''',
                controller: maxWordTextController,
                inputFormatter: FilteringTextInputFormatter.digitsOnly,
                validator: (value) => validateInteger(value, min: 1),
                stateProvider: maxWordProvider,
              ),

              NumberField(
                label: 'Min Freq',
                key: const Key('textMinFreq'),
                controller: minFreqTextController,

                tooltip: '''

                **Min Freq:** Specify here the mininum frequency of words that
                should be considered for analysis.

                ''',
                inputFormatter:
                    FilteringTextInputFormatter.digitsOnly, // Integers only
                validator: (value) => validateInteger(value, min: 1),
                stateProvider: minFreqProvider,
              ),

              NumberField(
                label: 'Cor Freq',
                key: const Key('textCorFreq'),
                tooltip: '''

                **Cor Freq:** This is the lower bound on the term frequency for
                the term to be included in the **Term Correlation Plot**.

                ''',
                controller: textCorFreqController,
                inputFormatter: FilteringTextInputFormatter.digitsOnly,
                interval: 1,
                validator: (value) => validateInteger(value, min: 1),
                stateProvider: textCorFreqProvider,
                min: 1,
              ),

              NumberField(
                label: 'Cor Limit',
                key: const Key('textCorLimit'),
                tooltip: '''

                **Correlation Limit:** This is used for the **Term Association**
                and **Term Correlation Plot** as the minimum correlation
                threshold (0-1) for associations between the **Cor Term**
                specified and other terms in the document term matrix.

                See
                [tm::findAssocs()](https://www.rdocumentation.org/packages/tm/topics/findAssocs).

                ''',
                controller: textCorLimitController,
                inputFormatter: FilteringTextInputFormatter.allow(
                  RegExp(r'^[0-9]*\.?[0-9]{0,4}$'),
                ),
                interval: 0.01,
                decimalPlaces: 2,
                validator: (value) => validateDecimal(value),
                stateProvider: textCorLimitProvider,
                min: 0.0,
                max: 1.0,
              ),

              buildTextField(
                label: 'Cor Term',
                controller: textCorWordController,
                key: const Key('textCorWordField'),
                textStyle: normalTextStyle,
                tooltip: '''

                **Cor Term:** The term here will be used to perform an
                association analysis to find other terms that are highly
                correlated with this term (at least with a correlation as
                specified as the **Cor Limit**) .

                See
                [tm::findAssocs()](https://www.rdocumentation.org/packages/tm/topics/findAssocs).

                ''',
                enabled: true,
                validator: (value) => null,
                inputFormatter: FilteringTextInputFormatter.allow(
                  RegExp(
                    r'^[a-zA-Z0-9,.\s]*$',
                  ), // Allow letters, digits, commas, dots, whitespace.
                ),
                maxWidth: 8,
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
        int.tryParse(maxWordTextController.text) ?? 100;
  }

  void _updateMinFreqProvider() {
    ref.read(minFreqProvider.notifier).state =
        int.tryParse(minFreqTextController.text) ?? 1;
  }

  void _updateSparseProvider() {
    ref.read(sparseMaxProvider.notifier).state =
        double.tryParse(sparseTextController.text) ?? 0.99;
  }

  void _updateTextCorWordProvider() {
    ref.read(textCorWordProvider.notifier).state = textCorWordController.text;
  }

  void _updateTextCorLimitProvider() {
    ref.read(textCorLimitProvider.notifier).state =
        double.tryParse(textCorLimitController.text) ?? 0.8;
  }

  void _updateTextCorFreqProvider() {
    ref.read(textCorFreqProvider.notifier).state =
        int.tryParse(textCorFreqController.text) ?? 20;
  }
}
