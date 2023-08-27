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

import 'package:flutter/material.dart';

import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:rattle/constants/app.dart';
import 'package:rattle/helpers/load_asset.dart';

/// A scrolling widget that parses and displays Markdown file,
/// which is located under the path [markdownFilePath].
/// It allows handling asynchronous loading of markdown file.

// 20230828 gjw NOT CURRENTLY USED SO COMMENT OUT FOR NOW.

// FutureBuilder markdownFileBuilder(String markdownFilePath) {
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

FutureBuilder sunkenMarkdownFileBuilder(String markdownFilePath) {
  return FutureBuilder(
    key: const Key('sunken_markdown_file'),
    future: loadAsset(markdownFilePath),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(1),
                spreadRadius: 10,
                blurRadius: 10,
                offset: const Offset(10, 10),
              ),
            ],
          ),
          child: Markdown(
            data: snapshot.data!,
            selectable: true,
            // Custom image builder to load assets.
            imageBuilder: (uri, title, alt) {
              return Image.asset('$assetsPath/${uri.toString()}');
            },
          ),
        );
      }

      return const Center(child: CircularProgressIndicator());
    },
  );
}
