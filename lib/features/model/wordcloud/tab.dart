import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/features/model/tab.dart';
import 'package:rattle/features/model/wordcloud/config.dart';
import 'package:rattle/features/model/wordcloud/save_png.dart';
import 'package:rattle/provider/wordcloud/build.dart';

class WordCloudTab extends ConsumerStatefulWidget {
  const WordCloudTab({super.key});
  @override
  ConsumerState<WordCloudTab> createState() => _WordCloudTabState();
}

class _WordCloudTabState extends ConsumerState<WordCloudTab> {
  @override
  Widget build(BuildContext context) {
    // debugPrint('wordcloud window build');
    // debugPrint('path: $wordCloudImagePath');
    // reload the wordcloud png
    imageCache.clear();
    imageCache.clearLiveImages();
    String rebuild = ref.watch(wordCloudBuildProvider);
    debugPrint('received rebuild on $rebuild');
    // debugPrint("build wordcloud window.");
    var wordCloudFile = File(wordCloudImagePath);
    bool pngBuild = wordCloudFile.existsSync();
    Widget rtn = const Text('bug');

    if (!pngBuild) {
      debugPrint('No model has been built.');
      rtn = const Column(
        children: [
          SizedBox(height: 50),
          Text('No model has been built'),
        ],
      );
    }

    if (pngBuild) {
      debugPrint('model built - sleeping if needed to wait for file');
      // reload the image (https://nambiarakhilraj01.medium.com/what-to-do-if-fileimage-imagepath-does-not-update-on-build-in-flutter-622ad5ac8bca

      var bytes = wordCloudFile.readAsBytesSync();

      // TODO 20240601 gjw WITHOUT THE DELAY HERE WE SEE AN EXCEPTION ON LINUX
      //
      // _Exception was thrown resolving an image codec:
      // Exception: Invalid image data
      //
      // ON PRINTING bytes WE SEE AN EMPYT LIST OF BYTES UNTIL THE FILE IS
      // LOADED SUCCESSFULLY.
      //
      // WITH THE SLEEP WE AVOID IT. SO WE SLEEP LONG ENOUGH FOR THE FILE THE BE
      // SUCCESSFULLY LOADED (BECUSE IT IS NOT YET WRITTEN?) SO WE NEED TO WAIT
      // UNTIL THE FILE IS READY.
      //
      // THERE MIGHT BE A BETTER WAY TO DO THIS - WAIT SYNCHRONLOUSLY?

      while (bytes.lengthInBytes == 0) {
        sleep(const Duration(seconds: 1));
        bytes = wordCloudFile.readAsBytesSync();
      }

      Image image = Image.memory(bytes);

      rtn = Column(
        children: [
          Text('Latest rebuild $rebuild'),
          image,
        ],
      );
    }

    return wrap(rtn);
  }
}

Widget wrap(Widget w) {
  return Column(
    children: [
      const WordCloudConfig(),
      SizedBox(
        height: 5,
      ),
      // TODO yyx tried to make the pane white by wrapping expanded with container. didn't work
      // Container(
      // color: Colors.blue,
      // child:
      Expanded(
        child:
            // Container(
            // color: Colors.black,
            // child:
            SingleChildScrollView(
          child: w,
        ),
      ),
      // ),
      // ),
      SizedBox(
        height: 5,
      ),
      WordCloudSaveButton(
        wordCloudImagePath: wordCloudImagePath,
      ),
    ],
  );
}
