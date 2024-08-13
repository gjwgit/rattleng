/// Helper widget to build the common text based pages.
//
// Time-stamp: <Monday 2024-08-12 08:11:10 +1000 Graham Williams>
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
/// Authors: Graham Williams

library;

// Group imports by dart, flutter, packages, local. Then alphabetically.
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:rattle/constants/app.dart';
import 'package:rattle/constants/spacing.dart';
import 'package:rattle/constants/sunken_box_decoration.dart';
import 'package:rattle/utils/word_wrap.dart';

class TextPage extends StatelessWidget {
  final String title;
  final String content;

  const TextPage({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: sunkenBoxDecoration,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MarkdownBody(
              data: wordWrap(title),
              selectable: true,
              onTapLink: (text, href, title) {
                final Uri url = Uri.parse(href ?? '');
                launchUrl(url);
              },
            ),
            // Wrap SelectableText in SingleChildScrollView for horizontal scrolling.

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SelectableText(
                content,
                style: monoTextStyle,
                // Ensure that text does not wrap, allowing horizontal scroll.

                textAlign: TextAlign.left,
              ),
            ),
            // 20240812 gjw Add a bottom spacer to leave a gap for the page
            // navigation whenscrolling to the bottom of the page so that it can
            // be visible in at least some part of any very busy pages.
            textPageBottomSpace,
            // 20240812 gjw Add a divider to mark the end of the text page.
            const Divider(
              thickness: 15,
              color: Color(0XFFBBDEFB),
              indent: 0,
              endIndent: 20,
            ),
          ],
        ),
      ),
    );
  }
}
