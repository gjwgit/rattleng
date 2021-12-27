import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/rcmd.dart' show cmd_initial_message, cmd_log_intro;


class LogTab extends StatelessWidget {
  const LogTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            const SizedBox(height: 10),
            ElevatedButton(
              child: const Text("Save Log to Script File"),
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
            Text(cmd_log_intro),
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SelectableText(cmd_initial_message,
            key: const Key('log_text'),
            style: const TextStyle(
              fontFamily: 'UbuntuMono',
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}
