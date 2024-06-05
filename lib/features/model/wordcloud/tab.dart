//

// TODO 20240605 gjw LICENSE AND COMMENTS REQUIRED

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
    // Build the word cloud widget to be deisplay in it's tab, consisting of the
    // top conguration and the main panel showing the generated image.

    // Reload the wordcloud image.

    imageCache.clear();
    imageCache.clearLiveImages();
    String rebuild = ref.watch(wordCloudBuildProvider);
    debugPrint('received rebuild on $rebuild');
    var wordCloudFile = File(wordCloudImagePath);
    bool pngBuild = wordCloudFile.existsSync();

    // Identify a widget for the display of the word cloud image file. Default
    // to a BUG display! The traditional 'This should not happen'.

    Widget imageDisplay = const Text('This should not happen.');

    if (!pngBuild) {
      debugPrint('No model has been built.');
      imageDisplay = const Column(
        children: [
          SizedBox(height: 50),
          Text('To build a word cloud you first need to load a txt dataset.\n'
              'Once a txt dataset has been loaded then tap the Build button.\n'
              'Various options and parameters will fine tune the word cloud.\n'
              'Tap the save icon in the top toolbar to save the image to file.\n'
              'Review the Script page for R commands used to build the word cloud.'),
        ],
      );
    }

    if (pngBuild) {
      debugPrint('model built - sleeping if needed to wait for file');

      // Reload the image:
      // (https://nambiarakhilraj01.medium.com/what-to-do-if-fileimage-imagepath-does-not-update-on-build-in-flutter-622ad5ac8bca

      var bytes = wordCloudFile.readAsBytesSync();

      // TODO 20240601 gjw WITHOUT A DELAY HERE WE SEE AN EXCEPTION ON LINUX
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

      // Build the widget to display the image. Make it a row, centering the
      // image horizontally, and so ensuring the scrollbar is all the way to the
      // right.

      imageDisplay = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          image,
        ],
      );
    }

    return wordCloudPanel(imageDisplay);
  }
}

Widget wordCloudPanel(Widget wordCloudBody) {
  return Container(
    color: Colors.white,
    child: Column(
      children: [
        const WordCloudConfig(),
        // TODO 20240605 gjw THIS FUNCTIONALITY TO MIGRATE TO THE APP SAVE
        // BUTTON TOP RIGHT.
        //
        // WordCloudSaveButton(
        //  wordCloudImagePath: wordCloudImagePath,
        // ),
        const SizedBox(
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
            child: wordCloudBody,
          ),
        ),
        // ),
        // ),
        const SizedBox(
          height: 5,
        ),
      ],
    ),
  );
}
