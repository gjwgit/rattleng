// add the build button in the tab
import 'package:flutter/widgets.dart';

Widget addBuildButton(Widget content, Widget buildButton) {
  return Column(
    children: [
      const SizedBox(
        height: 5,
      ),
      Row(
        children: [
          const SizedBox(
            width: 5,
          ),
          buildButton,
        ],
      ),
      content,
    ],
  );
}
