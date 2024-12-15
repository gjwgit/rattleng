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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:rattle/constants/app.dart';
import 'package:rattle/constants/sunken_box_decoration.dart';
import 'package:rattle/utils/load_asset.dart';

/// A scrolling widget that parses and displays Markdown file,
/// which is located under the path [markdownFilePath].
/// It allows handling asynchronous loading of markdown file.

FutureBuilder showMarkdownFile(
  String markdownFilePath,
  BuildContext context,
) {
  return FutureBuilder(
    key: const Key('markdown_file'),
    future: loadAsset(markdownFilePath),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        String svgAsset = 'assets/svg/generic.svg';

        return Container(
          decoration: sunkenBoxDecoration,

          // 20241215 gjw It is easier to read the overview text when it is not
          // too wide. For now, and assuming the default window width, place the
          // Markdown text into a row and half fill the row. Eventually probably
          // want a fixed width?

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

              // The right pain is empty.

              Expanded(
                child: SvgPicture.asset(
                  svgAsset,
                  width: 300, // You can adjust these dimensions
                  height: 500, // to fit your needs
                  fit: BoxFit.contain,
                  // colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                ),
                // child: SvgPicture.string(
                //   svgString,
                //   width: 300, // You can adjust these dimensions
                //   height: 500, // to fit your needs
                //   fit: BoxFit.contain,
                //   // colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                // ),
              ),
            ],
          ),
        );
      }

      return const Center(child: CircularProgressIndicator());
    },
  );
}
