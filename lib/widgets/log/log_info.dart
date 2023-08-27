/// A LOG info with a save button widget for the LOG tab page.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Sunday 2023-08-27 15:12:07 +1000 Graham Williams>
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:rattle/widgets/log/log_save_button.dart';

/// Create a log info widget with a Save button and displaying markdown.
///
/// The contents is intialised from log_intro.md markdown asset.

class LogInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Builder(
        builder: (BuildContext context) {
          return FutureBuilder(
            future: rootBundle.loadString('assets/markdown/log_intro.md'),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                return Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      LogSaveButton(),
                      SizedBox(height: 10),
                      // Markdown(data: File(logIntro).readAsStringSync()),
                      // sunkenMarkdownFileBuilder(logIntro),
                      Text(snapshot.data!),
                    ],
                  ),
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          );
        },
      ),
    );
  }
}
