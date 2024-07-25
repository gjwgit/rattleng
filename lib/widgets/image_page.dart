/// Helper widget to build the common image based pages.
//
// Time-stamp: <Thursday 2024-07-25 13:34:54 +1000 Graham Williams>
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
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:rattle/constants/sunken_box_decoration.dart';
import 'package:rattle/utils/select_file.dart';
import 'package:rattle/utils/word_wrap.dart';

class ImagePage extends StatelessWidget {
  final String title;
  final String path;

  const ImagePage({
    super.key,
    required this.title,
    required this.path,
  });

  Future<Uint8List> _loadImageBytes() async {
    var imageFile = File(path);

    // Wait until the file exists
    while (!await imageFile.exists()) {
      await Future.delayed(const Duration(seconds: 1));
    }

    // Read file as bytes
    return await imageFile.readAsBytes();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Image Path is $path');

    // Clear the image cache
    imageCache.clear();
    imageCache.clearLiveImages();

    return FutureBuilder<Uint8List>(
      future: _loadImageBytes(),
      builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
        var bytes = snapshot.data;
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && bytes != null && bytes.isNotEmpty) {
          return Container(
            decoration: sunkenBoxDecoration,
            width: double.infinity,
            padding: const EdgeInsets.only(left: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Introduce the Flexible wrapper to avoid the markdow
                      // text overflowing to the elevarted Export
                      // button. 20240725 gjw
                      Flexible(
                        child: MarkdownBody(
                          data: wordWrap(title),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () async {
                          String? pathToSave = await selectFile();
                          if (pathToSave != null) {
                            // Copy generated image from /tmp to user's location.
                            await File(path).copy(pathToSave);
                          }
                        },
                        child: const Text(
                          'Export',
                        ),
                      ),
                      const SizedBox(width: 5),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: InteractiveViewer(
                          maxScale: 5,
                          child: SvgPicture.memory(bytes),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
