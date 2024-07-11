/// Helper widget to build the common image based pages.
//
// Time-stamp: <Thursday 2024-07-11 19:50:01 +1000 Graham Williams>
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
/// Authors: Graham Williams, Yixiang Yin

library;

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:rattle/constants/sunken_box_decoration.dart';

class ImagePage extends StatelessWidget {
  final String title;
  final String path;

  const ImagePage({
    super.key,
    required this.title,
    required this.path,
  });

  @override
  Widget build(BuildContext context) {
    // Reload the wordcloud image.

    imageCache.clear();
    imageCache.clearLiveImages();
    var imageFile = File(path);
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

    // while (bytes.lengthInBytes == 0) {
    //   sleep(const Duration(seconds: 1));
    //   bytes = wordCloudFile.readAsBytesSync();
    // }
    // TODO yyx 20240701 what is the diff between sync and async?
    // wait to read the file until the file is available.
    // attempt to read it before that might give PathNotFound Exception (https://github.com/gjwgit/rattleng/issues/169)
    while (!imageFile.existsSync()) {
      sleep(const Duration(seconds: 1));
    }
    // Reload the image:
    // https://nambiarakhilraj01.medium.com/
    // what-to-do-if-fileimage-imagepath-does-not-update-on-build-in-flutter-622ad5ac8bca
    var bytes = imageFile.readAsBytesSync();

    Image image = Image.memory(bytes);

    // centering the image horizontally, and make it scrollable.
    return Container(
      decoration: sunkenBoxDecoration,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MarkdownBody(
              data: title,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [image],
            ),
          ],
        ),
      ),
    );
  }
}
