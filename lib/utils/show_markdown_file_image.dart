/// Render a markdown document as a widget with an optional SVG asset.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:rattle/constants/app.dart';
import 'package:rattle/constants/sunken_box_decoration.dart';
import 'package:rattle/utils/load_asset.dart';

// TODO 20241215 gjw MIGRATE ALL showMardownFile TO THAT IN show_markdown_file_image.dart

/// 20241215 gjw A scrolling widget that parses and displays Markdown file,
/// which is located under the path [markdownFilePath]. The markdown file takes
/// up the left half of the widget while an optional SVG image the right ahlf. A
/// generic image is displayed if no image is provided.  It allows handling
/// asynchronous loading of markdown file.

FutureBuilder showMarkdownFile(
  BuildContext context,
  String markdownFilePath, [
  String svgAsset = 'generic.svg',
]) {
  return FutureBuilder(
    key: const Key('markdown_file'),
    future: loadAsset(markdownFilePath),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Container(
          decoration: sunkenBoxDecoration,

          // 20241215 gjw It is easier to read the overview text when it is not
          // too wide. For now, and assuming the default window width, place the
          // Markdown text into a row and half fill the row.

          child: Row(
            children: [
              // The text goes into the left pane.

              Expanded(
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

              // 20241215 gjw The right pain is for an image.

              Expanded(
                child: SvgPicture.asset(
                  svgAsset,
                  width: 300, // You can adjust these dimensions
                  height: 500, // to fit your needs
                  fit: BoxFit.contain,
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
