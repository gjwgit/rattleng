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
    // debugPrint("wordcloud window build");
    // debugPrint('path: $wordcloudImagePath');
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
      debugPrint("model built - sleeping if needed to wait for file");
      // reload the image (https://nambiarakhilraj01.medium.com/what-to-do-if-fileimage-imagepath-does-not-update-on-build-in-flutter-622ad5ac8bca

      var bytes = wordcloudFile.readAsBytesSync();

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
      // THERE MUST NE A BETTER WAY TO DO THIS - WAIT SYNCHRONLOUSLY?

      while (bytes.lengthInBytes == 0) {
        sleep(const Duration(seconds: 1));
        bytes = wordcloudFile.readAsBytesSync();
      }

      Image image = Image.memory(bytes);

      rtn = Column(
        children: [
          Text("Latest rebuild $rebuild"),
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
      const WordcloudConfigBar(),
      SizedBox(
        height: 5,
      ),
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
      SaveWordcloudButton(
        wordcloudImagePath: wordcloudImagePath,
      ),
    ],
  );
}
