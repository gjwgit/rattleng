import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rattle/features/model/save_wordcloud_png.dart';
import 'package:rattle/features/model/tab.dart';
import 'package:rattle/features/model/wordcloud/config_bar.dart';
import 'package:rattle/provider/wordcloud/build.dart';

class WordcloudTab extends ConsumerStatefulWidget {
  const WordcloudTab({super.key});
  @override
  ConsumerState<WordcloudTab> createState() => _WordcloudTabState();
}

class _WordcloudTabState extends ConsumerState<WordcloudTab> {
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
    Widget rtn = const Text("bug");

    if (!pngBuild) {
      debugPrint("No model has been built.");
      rtn = const Column(
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
      rtn = Column(
        children: [
          Text("Latest rebuild $rebuild"),
          image,
          SaveWordcloudButton(
            wordcloudImagePath: wordcloudImagePath,
          ),
        ],
      );
    }
    return wrap(rtn);
  }
}

Widget wrap(Widget w) {
  return SingleChildScrollView(
    child: Column(
      children: [
        const WordcloudConfigBar(),
        w,
      ],
    ),
  );
}
