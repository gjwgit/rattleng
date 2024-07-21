/// The app's status bar.
///
/// Time-stamp: <Sunday 2024-07-21 17:28:48 +1000 Graham Williams>
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
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

import 'package:flutter/material.dart';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:rattle/constants/keys.dart';
import 'package:rattle/providers/path.dart';
import 'package:rattle/providers/status.dart';

class StatusBar extends ConsumerWidget {
  const StatusBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String path = ref.watch(pathProvider);
    if (path != '') path = '$path   ';

    return Container(
      height: 50,
      padding: const EdgeInsets.only(left: 0),
      // color: statusBarColor,
      child: Markdown(
        key: statusBarKey,
        selectable: true,
        onTapLink: (text, href, title) {
          final Uri url = Uri.parse(href ?? '');
          launchUrl(url);
        },
        data: '![](resource:assets/images/favicon_small.png)   '
            '[togware.com](https://togaware.com)  '
            '$path'
            '${ref.watch(statusProvider)}',
        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
      ),
    );
  }
}
