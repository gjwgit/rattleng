/// The LOG tab page.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Wednesday 2023-08-23 12:02:52 +1000 Graham Williams>
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

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rattle/constants/app.dart';
import 'package:rattle/widgets/save_log_button.dart';
import 'package:rattle/widgets/markdown_file.dart';

class LogTab extends StatelessWidget {
  const LogTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
            flex: 4,
            child: Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    SaveLogButton(),
                    SizedBox(height: 10),
                    // Markdown(data: File(logIntro).readAsStringSync()),
                    // sunkenMarkdownFileBuilder(logIntro),
                    Text(
                      File(logIntro).readAsStringSync(),
                    ),
                  ],
                ))),
        Expanded(
            flex: 7,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SelectableText(
                // TODO AVOID FILENAME LITERALS IN THE CODE
                File("assets/scripts/main.R").readAsStringSync(),
                key: const Key('log_text'),
                style: const TextStyle(
                  // fontFamily: 'UbuntuMono',
                  // fontSize: 14,
                  fontFamily: 'RobotoMono',
                  fontSize: 12,
                ),
              ),
            )),
      ],
    );
  }
}
