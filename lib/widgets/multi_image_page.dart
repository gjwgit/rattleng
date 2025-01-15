/// A widget to build the common image based pages.
//
// Time-stamp: <Friday 2024-12-27 16:10:14 +1100 Graham Williams>
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

import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:rattle/constants/temp_dir.dart';
import 'package:rattle/utils/select_file.dart';
import 'package:rattle/utils/show_image_dialog.dart';
import 'package:rattle/utils/show_ok.dart';

class MultiImagePage extends StatelessWidget {
  final List<String> titles;
  final List<String> paths;
  final String appBarImage;
  final bool svgImage;

  // If this is non-null, display it in the app bar alongside [appBarImage].
  // The combined text is rendered as Markdown.

  final String? buildHyperLink;

  const MultiImagePage({
    super.key,
    required this.titles,
    required this.paths,
    this.appBarImage = 'Hand',
    this.svgImage = true,
    this.buildHyperLink,
  });

  Future<Uint8List?> _loadImageBytes(String path) async {
    var imageFile = File(path);

    int retries = 5;
    while (!await imageFile.exists() && retries > 0) {
      await Future.delayed(const Duration(seconds: 1));
      retries--;
    }

    if (!await imageFile.exists()) {
      return null;
    }

    return await imageFile.readAsBytes();
  }

  /// Convert the file [svgPath] return [Future] image bytes in PNG format.
  ///
  /// Throws an [Exception] if the conversion fails.

  Future<ByteData> _svgToImageBytes(String svgPath) async {
    final svgString = await File(svgPath).readAsString();
    final pictureInfo = await vg.loadPicture(
      SvgStringLoader(svgString),
      null,
    );

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    final size = pictureInfo.size;

    canvas.scale(1.0, 1.0);
    final image = await pictureInfo.picture
        .toImage(size.width.toInt(), size.height.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) {
      throw Exception('Failed to convert SVG to image bytes');
    }

    return byteData;
  }

  Future<void> _exportToPdf(String svgPath, String pdfPath) async {
    final pngBytes = await _svgToImageBytes(svgPath);

    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(
              pw.MemoryImage(pngBytes.buffer.asUint8List()),
            ),
          );
        },
      ),
    );

    final file = File(pdfPath);
    await file.writeAsBytes(await pdf.save());
  }

  Future<void> _exportToPng(String svgPath, String pngPath) async {
    final pngBytes = await _svgToImageBytes(svgPath);

    final file = File(pngPath);
    await file.writeAsBytes(pngBytes.buffer.asUint8List());
  }

  @override
  Widget build(BuildContext context) {
    imageCache.clear();
    imageCache.clearLiveImages();
    final ScrollController _scrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: buildHyperLink == null
            ? Text(appBarImage)
            : MarkdownBody(
                data: wordWrap('''
                      **$appBarImage**
          
                      $buildHyperLink
                      '''),
                styleSheet: MarkdownStyleSheet(
                  // Force left alignment for paragraph text.

                  p: Theme.of(context).textTheme.bodyMedium ??
                      const TextStyle(),
                  textAlign: WrapAlignment.start,
                  strong: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTapLink: (text, href, title) {
                  if (href != null && href.isNotEmpty) {
                    launchUrl(Uri.parse(href));
                  }
                },
              ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              thickness: 8,
              radius: const Radius.circular(
                4,
              ), // Optional: customize scrollbar appearance
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: paths.length,
                itemBuilder: (context, index) {
                  return FutureBuilder<Uint8List?>(
                    future: _loadImageBytes(paths[index]),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.data == null ||
                          snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text(
                            'Image not available',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent,
                            ),
                          ),
                        );
                      } else {
                        final bytes = snapshot.data!;

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: MarkdownBody(
                                      data: wordWrap(titles[index]),
                                      selectable: true,
                                      onTapLink: (text, href, title) {
                                        final Uri url = Uri.parse(href ?? '');
                                        launchUrl(url);
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  MarkdownTooltip(
                                    message: '''
                    **Enlarge.** Tap here to view the plot enlarged to the
                    maximum size within the app.
                    ''',
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.zoom_out_map,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () {
                                        showImageDialog(context, bytes);
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  MarkdownTooltip(
                                    message: '''
                    **Open.** Tap here to open the plot in a separate window
                    to the Rattle app itself. This allows you to retain a
                    view of the plot while you navigate through other plots
                    and analyses. If you choose the external app to be
                    **Inkscape**, for example, then you can edit the plot,
                    including the text, colours, etc. Note that Inkscape can
                    be a little slow to startup. The choice of app depends
                    on your operating system settings and can be overridden
                    in the Rattle **Settings**.
                    ''',
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.open_in_new,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () async {
                                        String fileName =
                                            'plot_${Random().nextInt(10000)}.svg';
                                        File tempFile =
                                            File('$tempDir/$fileName');

                                        await File(paths[index])
                                            .copy(tempFile.path);

                                        final prefs = await SharedPreferences
                                            .getInstance();
                                        final imageViewerApp =
                                            prefs.getString('imageViewerApp');

                                        Platform.isWindows
                                            ? Process.run(
                                                imageViewerApp!,
                                                [tempFile.path],
                                                runInShell: true,
                                              )
                                            : Process.run(
                                                imageViewerApp!,
                                                [tempFile.path],
                                              );
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  MarkdownTooltip(
                                    message: '''
                    **Save.** Tap here to save the plot in your preferred
                    format (**svg**, **pdf**, or **png**). You can directly
                    choose your desired format by replacing the default
                    *svg* filename extension with either *pdf* or *png*. The
                    file is saved to your local storage. Perfect for
                    including in reports or keeping for future
                    reference. The **svg** format is particularly convenient
                    as you can edit all details of the plot with an
                    application like **Inkscape**.
                    ''',
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.save,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () async {
                                        String fileName =
                                            paths[index].split('/').last;
                                        String? pathToSave = await selectFile(
                                          defaultFileName: fileName,
                                          allowedExtensions: [
                                            'svg',
                                            'pdf',
                                            'png',
                                          ],
                                        );
                                        if (pathToSave != null) {
                                          String extension = pathToSave
                                              .split('.')
                                              .last
                                              .toLowerCase();
                                          if (extension == 'svg') {
                                            await File(paths[index])
                                                .copy(pathToSave);
                                          } else if (extension == 'pdf') {
                                            await _exportToPdf(
                                              paths[index],
                                              pathToSave,
                                            );
                                          } else if (extension == 'png') {
                                            await _exportToPng(
                                              paths[index],
                                              pathToSave,
                                            );
                                          } else {
                                            showOk(
                                              title: 'Error',
                                              context: context,
                                              content: '''
                  An unsupported filename extension was
                  provided: .$extension. Please try again
                  and select a filename with one of the
                  supported extensions: .svg, .pdf, or .png.
                  ''',
                                            );
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                ],
                              ),
                              Expanded(
                                child: InteractiveViewer(
                                  maxScale: 5,
                                  alignment: Alignment.topCenter,
                                  child: svgImage
                                      ? SvgPicture.memory(
                                          bytes,
                                          fit: BoxFit.scaleDown,
                                        )
                                      : Image.memory(bytes),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
