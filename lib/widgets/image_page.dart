/// Helper widget to build the common image based pages.
//
// Time-stamp: <Sunday 2024-08-18 09:00:48 +1000 Graham Williams>
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
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:rattle/constants/sunken_box_decoration.dart';
import 'package:rattle/constants/temp_dir.dart';
import 'package:rattle/utils/select_file.dart';
import 'package:rattle/utils/show_image_dialog.dart';
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
                    // 20240726 gjw Ensure the Save button is aligned at the
                    // top.
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 20240726 gjw Remove the Flexible for now. Perhaps avoid
                      // long text in the Image Page for now. Save button was
                      // not getting pushed all the way to the right after
                      // adding Flexible.
                      //
                      // 20240725 gjw Introduce the Flexible wrapper to avoid the markdow
                      // text overflowing to the elevarted Export
                      // button.

//                      Flexible(
//                        child:
                      MarkdownBody(
                        data: wordWrap(title),
                        selectable: true,
                        onTapLink: (text, href, title) {
                          final Uri url = Uri.parse(href ?? '');
                          launchUrl(url);
                        },
                      ),
                      //                      ),
                      const Spacer(),
                      //                      ElevatedButton(
                      IconButton(
                        icon: const Icon(
                          Icons.zoom_out_map,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          showImageDialog(context, bytes);
                        },
                        tooltip: 'Tap here to view the plot\n'
                            'enlarged.',
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.open_in_new,
                          color: Colors.blue,
                        ),
                        tooltip: 'Tap here to view the plot\n'
                            'in a separate window.',
                        onPressed: () {
                          // Generate a unique file name for the new file in the
                          // temporary directory.

                          String fileName =
                              'plot_${Random().nextInt(10000)}.svg';
                          File tempFile = File('$tempDir/$fileName');

                          // Copy the original file to the temporary file.

                          File originalFile = File(path);
                          tempFile
                              .writeAsBytesSync(originalFile.readAsBytesSync());

                          // Pop out a window to display the plot separate
                          // to the Rattle app.

                          Platform.isWindows
                              ? Process.run('start', [tempFile.path])
                              : Process.run('open', [tempFile.path]);
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.save,
                          color: Colors.blue,
                        ),
                        onPressed: () async {
                          String? pathToSave = await selectFile();
                          if (pathToSave != null) {
                            // Copy generated image from /tmp to user's location.
                            await File(path).copy(pathToSave);
                          }
                        },
                        tooltip: 'Tap here to save the plot\n'
                            'into an SVG file on local storage.',
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
