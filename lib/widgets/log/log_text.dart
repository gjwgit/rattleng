/// A LOG text widget for the LOG tab page.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Sunday 2023-08-27 15:47:18 +1000 Graham Williams>
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

/// Create a log text viewer that can scroll the text of the log widget.
///
/// The contents is intialised from the main.R script asset.

class LogText extends StatelessWidget {
  const LogText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Builder(
        builder: (BuildContext context) {
          return FutureBuilder(
            future: rootBundle.loadString('assets/scripts/main.R'),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                return SelectableText(
                  snapshot.data!,
                  key: const Key('log_text'),
                  style: const TextStyle(
                    // fontFamily: 'UbuntuMono',
                    // fontSize: 14,
                    fontFamily: 'RobotoMono',
                    fontSize: 12,
                  ),
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          );
        },
      ),
    );
  }
}
