/// A button to save the log to file.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
///
// Time-stamp: <Wednesday 2023-09-13 09:07:38 +1000 Graham Williams>
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

import 'dart:io' show File;

import 'package:flutter/material.dart';

// TODO MOVE TO provider USING script INSIDE RATTLE DATA MODEL.

// ignore:  depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart' show find;

class LogSaveButton extends StatelessWidget {
  const LogSaveButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text("Export"),
      onPressed: () {
        debugPrint("SAVE SCRIPT TO SCRIPT.R");
        debugPrint("TODO PROMPT FOR THE NAME TO SAVE TO.");

        //var tv = find.byType(Text);
        //var tv = find.textContaining(RegExp(r"^#===.*"));
        var tv = find.byKey(const Key('log_text'));
        //debugPrint(tv.evaluate());
        // How to extract the text????
        //File('script.R').writeAsString(tv.evaluate().toString());

        //var ts = tv.data;
        var ts = tv.evaluate().toString();
        // ts = ts.replaceFirst(RegExp(r"^[^#]*#"), '    #');
        // ts = ts.replaceFirst(RegExp(r"  , style:.*"), '');
        // ts = ts.replaceAll(RegExp(r"\\n   "), '');

        File('script.R').writeAsString(ts);
        debugPrint("LOG WRITTEN TO `script.R`");

        //var tv = find.byKey(Key('log_text')).evaluate().first.widget; => "LogTab"
        //var tv = find.byKey(Key('log_text')).evaluate().first;
        //var tv = find.byKey(Key('log_text')).evaluate();
        //File('script.R').writeAsString(tv.toString());
        //var tx = tv.evaluate().first.widget;
        //debugPrint(tx);
        // File('script.R').writeAsString(tx);
      },
    );
  }
}
