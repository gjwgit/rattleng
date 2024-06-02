import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rattle/features/model/tab.dart';
import 'package:rattle/provider/wordcloud/checkbox.dart';
import 'package:rattle/provider/wordcloud/maxword.dart';
import 'package:rattle/provider/wordcloud/minfreq.dart';
import 'package:rattle/provider/wordcloud/punctuation.dart';
import 'package:rattle/provider/wordcloud/stem.dart';
import 'package:rattle/provider/wordcloud/stopword.dart';

class WordcloudConfigBar extends ConsumerStatefulWidget {
  const WordcloudConfigBar({super.key});

  @override
  ConsumerState<WordcloudConfigBar> createState() => _ConfigBarState();
}

class _ConfigBarState extends ConsumerState<WordcloudConfigBar> {
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
    return Column(
      children: [
        const SizedBox(height: 5.0),
        Row(
          children: [
            const SizedBox(width: 5.0),
            buildButton,
            const SizedBox(width: 20.0),
            const Text(
              'A wordcloud visualises word frequencies. '
              'More frequent words are larger.',
            ),
          ],
        ),
        const SizedBox(height: 20.0),
        Row(
          children: [
            const Text('Tuning Options:  '),
            // checkbox for random color
            Row(
              children: [
                Checkbox(
                  value: ref.watch(checkboxProvider),
                  onChanged: (bool? v) => {
                    ref.read(checkboxProvider.notifier).state = v!,
                  },
                ),
                const Text("Random Order"),
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
                const Text("Stem"),
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
                const Text("Remove Stopwords"),
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
                const Text("Remove Punctuation"),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
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
                    labelText: "Max Words",
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
                    labelText: "Min Freq",
                    labelStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _updateMaxWordProvider() {
    debugPrint("max word text changed to ${maxWordTextController.text}");
    ref.read(maxWordProvider.notifier).state = maxWordTextController.text;
  }

  void _updateMinFreqProvider() {
    debugPrint("min freq text changed to ${minFreqTextController.text}");
    ref.read(minFreqProvider.notifier).state = minFreqTextController.text;
  }
}
