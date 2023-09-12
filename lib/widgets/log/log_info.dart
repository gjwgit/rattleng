/// A LOG info with a save button widget for the LOG tab page.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Saturday 2023-09-09 17:33:32 +1000 Graham Williams>
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

import 'package:rattle/constants/app.dart';
import 'package:rattle/widgets/log/log_save_button.dart';
import 'markdown_widget.dart';

/// Create a log info widget with a Save button and displaying markdown.
///
/// The contents is intialised from log_intro.md markdown asset.

class LogInfo extends StatelessWidget {
  const LogInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Log info widget is created");
    return SingleChildScrollView(
      child: Builder(
        builder: (BuildContext context) {
          return FutureBuilder(
            future: rootBundle.loadString(logIntroFile),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return snapshot.hasData
                  ? Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          const LogSaveButton(),
                          const SizedBox(height: 10),
                          // Markdown(data: "**Sample data**"),
                          // sunkenMarkdownFileBuilder(logIntro),

                          //Make a custom widget that renders markdown using the
                          //Markdown package
                          // Text(snapshot.data! +
                          // " \n This has to be redered as markdown"),
                          MarkDownWidget(snapshot.data!)
                        ],
                      ),
                    )
                  : const CircularProgressIndicator();
            },
          );
        },
      ),
    );
  }
}
