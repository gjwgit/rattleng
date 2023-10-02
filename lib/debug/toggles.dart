import 'package:flutter/material.dart';

import 'package:rattle/constants/app.dart';
import 'package:rattle/debug/stderr_text.dart';
import 'package:rattle/debug/stdout_text.dart';

class DebugToggles extends StatefulWidget {
  const DebugToggles({super.key});

  @override
  State<DebugToggles> createState() => _DebugTogglesState();
}

class _DebugTogglesState extends State<DebugToggles> {
  int _selectedToggleIndex = 0;

  // Define widgets for each toggle option
  final List<Widget> _toggleWidgets = [
    const StdoutText(),
    const StderrText(),
    const Text('Rattle State'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ToggleButtons

          Container(
            padding: const EdgeInsets.all(16.0),
            child: ToggleButtons(
              isSelected:
                  List.generate(3, (index) => index == _selectedToggleIndex),
              onPressed: (int newIndex) {
                setState(() {
                  _selectedToggleIndex = newIndex;
                });
              },
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              selectedBorderColor: statusBarColour,
              selectedColor: Colors.white,
              fillColor: headerBarColour,
              color: Colors.grey, //red[400],
              constraints: const BoxConstraints(
                minHeight: 40.0,
                minWidth: 200.0,
              ),
              children: const [
                Text('R Standard Output'),
                Text('R Standard Error'),
                Text('Rattle State'),
              ],
            ),
          ),

          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  // Display selected widget
                  Visibility(
                    visible: _selectedToggleIndex == 0,
                    child: _toggleWidgets.first,
                  ),

                  Visibility(
                    visible: _selectedToggleIndex == 1,
                    child: _toggleWidgets[1],
                  ),

                  Visibility(
                    visible: _selectedToggleIndex == 2,
                    child: _toggleWidgets[2],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
