/// The app's status bar.
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
/// Authors: Graham Williams

import 'package:flutter/material.dart';

//import 'package:rattle/src/models/rattle_model.dart';

import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:rattle/src/constants/app.dart';
import 'package:rattle/src/constants/keys.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
//    return Consumer<RattleModel>(
    // As a [Consumer] of the [RattleModel] recording the app's state we can
    // access the status message as it gets updated, so that the status bar
    // remains up to date.

//      builder: (context, rattle, child) {
    // The builder takes a context, a RattleModel, and the child. It is the
    // `rattle` that contains the state that we can access here.

    return Container(
      // I am setting the height for the bottom bar but this does not really
      // seem to be the way to do this.
      height: 50,
      padding: const EdgeInsets.only(left: 0),
      color: statusBarColour,
      child: Markdown(
        key: statusBarKey,
        selectable: true,
        data: "rattle.status",
        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
      ),
    );
//      },
//    );
  }
}
