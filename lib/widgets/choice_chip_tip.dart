/// An Expanded Wrap ChoiceChip used across the app.
//
// Time-stamp: <Sunday 2024-08-11 19:08:28 +1000 Graham Williams>
//
/// Copyright (C) 2024, Togaware Pty Ltd
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
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

library;

import 'package:flutter/material.dart';

import 'package:rattle/constants/spacing.dart';
import 'package:rattle/utils/word_wrap.dart';

class ChoiceChipTip extends StatefulWidget {
  final Map<String, String> choices;
  final Function(String) onSelectionChanged;

  const ChoiceChipTip({
    super.key,
    required this.choices,
    required this.onSelectionChanged,
  });

  @override
  ChoiceChipTipState createState() => ChoiceChipTipState();
}

class ChoiceChipTipState extends State<ChoiceChipTip> {
  String? chosen;

  @override
  void initState() {
    super.initState();
    // Set the default selected choice to the first item in the list.

    chosen =
        widget.choices.isNotEmpty ? widget.choices.keys.toList().first : null;

    // Notify the parent widget of the default selection.

    if (chosen != null) {
      widget.onSelectionChanged(chosen!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Wrap(
        spacing: 5.0,
        runSpacing: choiceChipRowSpace,
        children: widget.choices.keys.toList().map((choice) {
          return ChoiceChip(
            label: Text(choice),
            tooltip: wordWrap(widget.choices[choice] ?? ''),
            disabledColor: Colors.grey,
            selectedColor: Colors.lightBlue[200],
            backgroundColor: Colors.lightBlue[50],
            shadowColor: Colors.grey,
            pressElevation: 8.0,
            elevation: 2.0,
            selected: chosen == choice,
            onSelected: (bool selected) {
              setState(() {
                chosen = selected ? choice : '';
              });
              widget.onSelectionChanged(chosen!);
            },
          );
        }).toList(),
      ),
    );
  }
}
