/// Render a markdown document as a widget.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
// Licensed under the GNU General Public License, Version 3 (the "License");
///
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
/// Authors: Zheyuan Xu, Graham Williams

library;

import 'package:flutter/material.dart';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:rattle/constants/app.dart';
import 'package:rattle/constants/sunken_box_decoration.dart';
import 'package:rattle/utils/load_asset.dart';

/// A scrolling widget that parses and displays Markdown file,
/// which is located under the path [markdownFilePath].
/// It allows handling asynchronous loading of markdown file.

// 20230828 gjw NOT CURRENTLY USED SO COMMENT OUT FOR NOW.
//
// FutureBuilder showMarkdownFile(String markdownFilePath) {
//   return FutureBuilder(
//     key: const Key('markdown_file'),
//     future: loadAsset(markdownFilePath),
//     builder: (context, snapshot) {
//       if (snapshot.hasData) {
//         return Markdown(
//           data: snapshot.data!,
//           // Custom image builder to load assets.
//           imageBuilder: (uri, title, alt) {
//             return Image.asset('$assetsPath/${uri.toString()}');
//           },
//         );
//       }

//       return const Center(child: CircularProgressIndicator());
//     },
//   );
// }

FutureBuilder showMarkdownFile(String markdownFilePath, BuildContext context) {
  return FutureBuilder(
    key: const Key('markdown_file'),
    future: loadAsset(markdownFilePath),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Container(
// To avoid this error, provide a height limit at a higher (parent) level using the expanded() widget. The higher the better.
// The following assertion was thrown during performResize():
// Vertical viewport was given unbounded height.
// Viewports expand in the scrolling direction to fill their container. In this case, a vertical
// viewport was given an unlimited amount of vertical space in which to expand. This situation
// typically happens when a scrollable widget is nested inside another scrollable widget.
// If this widget is always nested in a scrollable widget there is no need to use a viewport because
// there will always be enough vertical space for the children. In this case, consider using a Column
// or Wrap instead. Otherwise, consider using a CustomScrollView to concatenate arbitrary slivers into
// a single scrollable.
// The relevant error-causing widget was:
//   ListView
//   ListView:file:///Users/yinyixiang/.pub-cache/hosted/pub.dev/flutter_markdown-0.7.1/lib/src/widget.dart:559:12
          decoration: sunkenBoxDecoration,
          child: Center(
            child: Markdown(
              data: snapshot.data!,
              selectable: true,
              onTapLink: (text, href, title) {
                final Uri url = Uri.parse(href ?? '');
                launchUrl(url);
              },
              // Custom image builder to load assets.
              imageBuilder: (uri, title, alt) {
                return Image.asset('$assetsPath/${uri.toString()}');
              },
            ),
          ),
        );
      }

      return const Center(child: CircularProgressIndicator());
    },
  );
}

FutureBuilder showMarkdownFileNew(
    String markdownFilePath, BuildContext context, List<String> resources) {
  return FutureBuilder(
    key: const Key('markdown_file_new'),
    future: loadAsset(markdownFilePath),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        // Wrap the markdown data into rows with a maximum of 100 characters.
        final wrappedMarkdown = _wrapText(snapshot.data!, 50);

        return Container(
          decoration: sunkenBoxDecoration,
          child: Row(
            children: [
              // Left side: Markdown content taking 50% of the screen width.
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Markdown(
                    data: wrappedMarkdown,
                    selectable: true,
                    onTapLink: (text, href, title) {
                      final Uri url = Uri.parse(href ?? '');
                      launchUrl(url);
                    },
                    imageBuilder: (uri, title, alt) {
                      return Image.asset('$assetsPath/${uri.toString()}');
                    },
                  ),
                ),
              ),

              // Right side: Resource list taking 50% of the screen width.
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Resources',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: resources.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                resources[index],
                                style: const TextStyle(fontSize: 14),
                              ),
                              onTap: () {
                                // Implement your onTap behavior here.
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }

      return const Center(child: CircularProgressIndicator());
    },
  );
}

// Function to wrap text at a specified character limit per row.
String _wrapText(String text, int limit) {
  final buffer = StringBuffer();
  final words = text.split(' ');

  String currentLine = '';

  for (final word in words) {
    if ((currentLine.length + word.length + 1) <= limit) {
      currentLine += (currentLine.isEmpty ? '' : ' ') + word;
    } else {
      buffer.writeln(currentLine);
      currentLine = word;
    }
  }

  if (currentLine.isNotEmpty) {
    buffer.writeln(currentLine); // Add the last line.
  }

  return buffer.toString();
}
