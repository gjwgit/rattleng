/// Load a markdown file.
///
/// Authors: Zheyuan Xu, Graham Williams

import 'package:flutter/material.dart';

import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:rattle/constants/app.dart';
import 'package:rattle/helpers/assets_load.dart';

/// A scrolling widget that parses and displays Markdown file,
/// which is located under the path [markDownFilePath].
/// It allows handling asynchronous loading of markdown file.

FutureBuilder markdownFileBuilder(String markDownFilePath) {
  return FutureBuilder(
    key: const Key('MarkdownFile'),
    future: loadMarkdownFromAsset(markDownFilePath),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Markdown(
          data: snapshot.data!,
          // Custom image builder to load assets.
          imageBuilder: (uri, title, alt) {
            return Image.asset('$assetsPath/${uri.toString()}');
          },
        );
      }

      return const Center(child: CircularProgressIndicator());
    },
  );
}

FutureBuilder sunkenMarkdownFileBuilder(String markDownFilePath) {
  return FutureBuilder(
    key: const Key('MarkdownFile'),
    future: loadMarkdownFromAsset(markDownFilePath),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
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
