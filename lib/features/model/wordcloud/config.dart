/// The WordCloud configuration panel.
//
// Time-stamp: <Wednesday 2024-06-12 10:13:40 +1000 Graham Williams>
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

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/features/model/tab.dart';
import 'package:rattle/features/model/build_button.dart';
// TODO 20240605 gjw PERHAPS CALL THIS randomProviderWC RATHER THAN
// THE GENERIC checkboxProvider? FOR DISCUSSION.
import 'package:rattle/provider/wordcloud/checkbox.dart';
// TODO 20240605 gjw We will have other providers as the app grows. maxword
// might be used in other panels too. Perhaps we need to identify these as
// WordCloud providers, perhaps within a wordcloudProvider structure?
import 'package:rattle/provider/wordcloud/build.dart';
import 'package:rattle/provider/wordcloud/maxword.dart';
import 'package:rattle/provider/wordcloud/minfreq.dart';
import 'package:rattle/provider/wordcloud/punctuation.dart';
import 'package:rattle/provider/wordcloud/stem.dart';
import 'package:rattle/provider/wordcloud/stopword.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/utils/timestamp.dart';
import 'package:rattle/widgets/activity_button.dart';

class WordCloudConfig extends ConsumerStatefulWidget {
  const WordCloudConfig({super.key});

  @override
  ConsumerState<WordCloudConfig> createState() => _ConfigState();
}

class _ConfigState extends ConsumerState<WordCloudConfig> {
  final maxWordTextController = TextEditingController();
  final minFreqTextController = TextEditingController();
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
    // Layout the config bar.
    return Column(
      children: [
        const SizedBox(height: 5.0),

        // A BUILD button and functionality explanation.

        Row(
          children: [
            const SizedBox(width: 5.0),

            // buildButton,

            ActivityButton(
              onPressed: () async {
                debugPrint('WC CONFIG BUTTON');
                // context.read(pngPathProvider).state =
                // clean up the files from previous use
                File oldWordcloudFile = File(wordCloudImagePath);
                if (oldWordcloudFile.existsSync()) {
                  oldWordcloudFile.deleteSync();
                  debugPrint('old wordcloud file deleted');
                } else {
                  debugPrint('old wordcloud file not exists');
                }
                File oldTmpFile = File(tmpImagePath);
                if (oldTmpFile.existsSync()) {
                  oldTmpFile.deleteSync();
                  debugPrint('old tmp file deleted');
                } else {
                  debugPrint('old tmp file not exists');
                }
                rSource(ref, 'model_build_word_cloud');
                final file = File(wordCloudImagePath);
                while (true) {
                  if (await file.exists()) {
                    debugPrint('file exists');
                    break;
                  }
                }
                // Toggle the state to trigger rebuild
                debugPrint('build clicked on ${timestamp()}');
                ref.read(wordCloudBuildProvider.notifier).state = timestamp();
              },
              child: const Text('Build'),
            ),

            const SizedBox(width: 20.0),
            const Text(
              'A word cloud visualises word frequencies. '
              'More frequent words are larger.',
            ),
          ],
        ),
        const SizedBox(height: 20.0),

        // Options for the current functionality.

        Row(
          children: [
            const Text('Tuning Options:  '),
            // Checkbox for random order of words in the cloud.
            Row(
              children: [
                Checkbox(
                  value: ref.watch(checkboxProvider),
                  onChanged: (bool? v) => {
                    ref.read(checkboxProvider.notifier).state = v!,
                  },
                ),
                const Text('Random Order'),
              ],
            ),
            const SizedBox(width: 20),
            Row(
              children: [
                Checkbox(
                  value: ref.watch(stemProvider),
                  onChanged: (bool? v) => {
                    ref.read(stemProvider.notifier).state = v!,
                  },
                ),
                const Text('Stem'),
              ],
            ),
            const SizedBox(width: 20),
            Row(
              children: [
                Checkbox(
                  value: ref.watch(stopwordProvider),
                  onChanged: (bool? v) => {
                    ref.read(stopwordProvider.notifier).state = v!,
                  },
                ),
                const Text('Remove Stopwords'),
              ],
            ),
            const SizedBox(width: 20),
            Row(
              children: [
                Checkbox(
                  value: ref.watch(punctuationProvider),
                  onChanged: (bool? v) => {
                    ref.read(punctuationProvider.notifier).state = v!,
                  },
                ),
                const Text('Remove Punctuation'),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Parameters for the current functionality.

        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            children: [
              const Text('Tuning Parameters:  '),
              const SizedBox(width: 5),
              // max word text field
              SizedBox(
                width: 150.0,
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
              const SizedBox(width: 20),
              SizedBox(
                width: 150.0,
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
            ],
          ),
        ),

        // Add a little sapce below the underlined input widgets so the
        // underline is not lost.

        const SizedBox(height: 10),
      ],
    );
  }

  void _updateMaxWordProvider() {
    debugPrint('max word text changed to ${maxWordTextController.text}');
    ref.read(maxWordProvider.notifier).state = maxWordTextController.text;
  }

  void _updateMinFreqProvider() {
    debugPrint('min freq text changed to ${minFreqTextController.text}');
    ref.read(minFreqProvider.notifier).state = minFreqTextController.text;
  }
}
