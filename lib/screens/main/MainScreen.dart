import 'package:flutter/material.dart';

import 'package:rattle/components/SideMenu.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: SideMenu(),
          ),
          Expanded(
            flex: 8,
            child:
              Text("BODY",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)), //loadingScreen,
            ),
          ],
        ),
    );
  }
}
