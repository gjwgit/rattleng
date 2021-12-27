import 'package:flutter/material.dart';

import 'package:rattle/components/tabs.dart';


class MainScreen extends StatelessWidget {
  const MainScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 10,
            child: Tabs(),
          ),
          Expanded(
            flex: 1,
            child: Text("FOOTER")
          ),
        ],
      ),
    );
  }
}
