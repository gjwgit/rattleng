/// Render two markdown documents as a widget.
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

FutureBuilder showMarkdownFile2(
  String markdownFilePath,
  String newMarkdownFilePath,
  BuildContext context,
) {
  return FutureBuilder(
    key: const Key('markdown_file_new'),
    future: loadAsset(markdownFilePath),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        // Wrap the markdown data into rows with a maximum of 100 characters.

        final wrappedMarkdown = _wrapText(snapshot.data!, 100);

        return FutureBuilder(
          future: loadAsset(newMarkdownFilePath),
          builder: (context, newSnapshot) {
            if (newSnapshot.hasData) {
              // Wrap the new markdown data as well.

              final wrappedNewMarkdown = _wrapText(newSnapshot.data!, 100);

              return Container(
                decoration: sunkenBoxDecoration,
                child: Row(
                  children: [
                    // Left side: Original Markdown content taking 50% of the screen width.

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

                    // Right side: New Markdown content taking 50% of the screen width.

                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Markdown(
                          data: wrappedNewMarkdown,
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
                  ],
                ),
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
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
    // Add the last line.

    buffer.writeln(currentLine);
  }

  return buffer.toString();
}
