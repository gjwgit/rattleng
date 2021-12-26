import 'package:flutter/material.dart';

// import 'package:folder_file_saver/folder_file_saver.dart';

import 'package:rattle/helpers/rcmd.dart';


class LogTab extends StatelessWidget {
  const LogTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      // padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              SizedBox(height: 10),
              ElevatedButton(
                child: Text("Save Log to Script File"),
                onPressed: () {
                  print("Okay - we will save the script to model.R");
                  print("Prompt for the name to save to.");
                  print("Extract text for Log Tab's Text Widget.");
                },
              ),
              SizedBox(height: 10),
              Text(cmd_log_intro),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Text(cmd_initial_message,
              style: TextStyle(
                fontFamily: 'UbuntuMono',
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
