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

FutureBuilder showMarkdownFile(String markdownFilePath, Context context) {
      final curHeight = MediaQuery.of(context).size.height;

  return FutureBuilder(
    key: const Key('markdown_file'),
    future: loadAsset(markdownFilePath),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Container(
          height: curHeight * 0.67, 
// avoid this error
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
