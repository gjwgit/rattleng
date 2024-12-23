/// A SCRIPT info with a save button widget for the SCRIPT tab page.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Thursday 2024-12-19 12:06:29 +1100 Graham Williams>
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

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:rattle/constants/app.dart';

/// Create a script info widget with a Save button and displaying markdown.
///
/// The contents is intialised from script_intro.md markdown asset.

class ScriptInfo extends StatelessWidget {
  const ScriptInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Builder(
        builder: (BuildContext context) {
          String rImagePath = 'assets/svg/script.svg';

          // WHY USING FUTURE BUILDER HERE?
          return FutureBuilder(
            future: rootBundle.loadString(scriptIntroFile),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return snapshot.hasData
                  ? Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
//                        spacing: 200,
                        children: [
                          MarkdownBody(data: snapshot.data!),
                          SvgPicture.asset(
                            rImagePath,
//                            width: 200,
//                            height: 200,
                            fit: BoxFit.contain,
                          ),
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
