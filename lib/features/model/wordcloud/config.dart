/// The WordCloud configuration panel.

// TODO 20240605 gjw REQUIRES LICENSE AND DOCUMENTATION.

library;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/app.dart';
import 'package:rattle/features/model/tab.dart';
// TODO 20240605 gjw PERHAPS CALL THIS randomProviderWC RATHER THAN
// THE GENERIC checkboxProvider? FOR DISCUSSION.
import 'package:rattle/provider/wordcloud/checkbox.dart';
// TODO 20240605 gjw We will have other providers as the app grows. maxword
// might be used in other panels too. Perhaps we need to identify these as
// WordCloud providers, perhaps within a wordcloudProvider structure?
import 'package:rattle/provider/wordcloud/maxword.dart';
import 'package:rattle/provider/wordcloud/minfreq.dart';
import 'package:rattle/provider/wordcloud/punctuation.dart';
import 'package:rattle/provider/wordcloud/stem.dart';
import 'package:rattle/provider/wordcloud/stopword.dart';

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
    return Container(
      // Set the default colour for the config bar background.

      color: configBarColor,

      // Layout the config bar.

      child: Column(
        children: [
          const SizedBox(height: 5.0),

          // A BUILD button and functionality explanation.

          Row(
            children: [
              const SizedBox(width: 5.0),
              buildButton,
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
      ),
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
