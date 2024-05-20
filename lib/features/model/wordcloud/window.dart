import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rattle/features/model/save_wordcloud_png.dart';
import 'package:rattle/features/model/tab.dart';
import 'package:rattle/provider/wordcloud/build.dart';

class WordcloudWindow extends ConsumerStatefulWidget {
  const WordcloudWindow({Key? key}) : super(key: key);
  @override
  ConsumerState<WordcloudWindow> createState() => _WordcloudWindowState();

  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint("wordcloud window build");
    debugPrint('path: $wordcloudImagePath');
    // reload the wordcloud png
    imageCache.clear();
    imageCache.clearLiveImages();
    String rebuild = ref.watch(wordcloudBuildProvider);
    debugPrint("received rebuild on $rebuild");
    // debugPrint("build wordcloud window.");
    var wordcloudFile = File(wordcloudImagePath);
    bool pngBuild = wordcloudFile.existsSync();
    if (!pngBuild) {
      debugPrint("No model has been built.");
      return const Column(
        children: [
          SizedBox(height: 50),
          Text("No model has been built"),
        ],
      );
    }

    if (pngBuild) {
      debugPrint("Wordcloud has been built.");

      return Column(
        children: [
          Image.file(File(wordcloudImagePath)),
          SaveWordcloudButton(
            wordcloudImagePath: wordcloudImagePath,
          ),
        ],
      );
    }
    return const Text("bug");
  }
}

class _WordcloudWindowState extends ConsumerState<WordcloudWindow> {
  @override
  Widget build(BuildContext context) {
    debugPrint("wordcloud window build");
    debugPrint('path: $wordcloudImagePath');
    // reload the wordcloud png
    imageCache.clear();
    imageCache.clearLiveImages();
    String rebuild = ref.watch(wordcloudBuildProvider);
    debugPrint("received rebuild on $rebuild");
    // debugPrint("build wordcloud window.");
    var wordcloudFile = File(wordcloudImagePath);
    bool pngBuild = wordcloudFile.existsSync();
    if (!pngBuild) {
      debugPrint("No model has been built.");
      return const Column(
        children: [
          SizedBox(height: 50),
          Text("No model has been built"),
        ],
      );
    }

    if (pngBuild) {
      debugPrint("model has been built.");
      // reload the image (https://nambiarakhilraj01.medium.com/what-to-do-if-fileimage-imagepath-does-not-update-on-build-in-flutter-622ad5ac8bca
      var bytes = wordcloudFile.readAsBytesSync();
      Image image = Image.memory(bytes);
      return Column(
        children: [
          Text("Latest rebuild $rebuild"),
          image,
          SaveWordcloudButton(
            wordcloudImagePath: wordcloudImagePath,
          ),
        ],
      );
    }
    return const Text("bug");
  }
}