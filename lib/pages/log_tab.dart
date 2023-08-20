// MLHub demonstrator and toolkit for kmeans.
//
// Time-stamp: <Sunday 2023-08-20 20:16:22 +1000 Graham Williams>
//
// Authors: Gefei Shan, Graham.Williams@togaware.com
// License: General Public License v3 GPLv3
// License: https://www.gnu.org/licenses/gpl-3.0.en.html
// Copyright: (c) Gefei Shan, Graham Williams. All rights reserved.

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/rcmd.dart' show cmdInitialMessage, cmdLogIntro;

class LogTab extends StatelessWidget {
  const LogTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(flex: 1, child: SizedBox(width: 1)),
        Expanded(
            flex: 4,
            child: Column(
              children: [
                const SizedBox(height: 10),
                ElevatedButton(
                  child: const Text("Save Log"),
                  onPressed: () {
                    print("DEBUG we will save the script to script.R");
                    print("Prompt for the name to save to.");
                    print("Extract text for Log Tab's Text Widget.");
                    //var tv = find.byType(Text);
                    //var tv = find.textContaining(RegExp(r"^#===.*"));
                    var tv = find.byKey(const Key('log_text'));
                    //print(tv.evaluate());
                    // How to extract the text????
                    //File('script.R').writeAsString(tv.evaluate().toString());

                    var ts = tv.evaluate().toString();
                    ts = ts.replaceFirst(RegExp(r"^[^#]*#"), '    #');
                    ts = ts.replaceFirst(RegExp(r"  , style:.*"), '');
                    ts = ts.replaceAll(RegExp(r"\\n   "), '');
                    print(ts);
                    File('script.R').writeAsString(ts);

                    //var tv = find.byKey(Key('log_text')).evaluate().first.widget; => "LogTab"
                    //var tv = find.byKey(Key('log_text')).evaluate().first;
                    //var tv = find.byKey(Key('log_text')).evaluate();
                    //File('script.R').writeAsString(tv.toString());
                    //var tx = tv.evaluate().first.widget;
                    //print(tx);
                    // File('script.R').writeAsString(tx);
                  },
                ),
                const SizedBox(height: 10),
                Text(cmdLogIntro),
              ],
            )),
        Expanded(flex: 1, child: SizedBox(width: 1)),
        Expanded(
            flex: 14,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SelectableText(
                cmdInitialMessage,
                key: const Key('log_text'),
                style: const TextStyle(
                  fontFamily: 'UbuntuMono',
                  fontSize: 18,
                ),
              ),
            )),
      ],
    );
  }
}
