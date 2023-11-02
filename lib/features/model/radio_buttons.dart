/// Radio buttons to choose the model to build.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
// Time-stamp: <Friday 2023-11-03 09:06:19 +1100 Graham Williams>
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

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/provider/model.dart';
import 'package:rattle/provider/stdout.dart';
import 'package:rattle/r/source.dart';

class ModelRadioButtons extends ConsumerStatefulWidget {
  const ModelRadioButtons({Key? key}) : super(key: key);

  @override
  ConsumerState<ModelRadioButtons> createState() => ModelRadioButtonsState();
}

class ModelRadioButtonsState extends ConsumerState<ModelRadioButtons> {
  // List of modellers we support.

  List<String> modellers = ['Cluster', 'Associate', 'Tree', 'Forest', 'Boost'];

  // Default selected valueas an idex into the modellers.

  int selectedValue = 2;

  void selectRadio(int value) {
    setState(() {
      selectedValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    String model = ref.watch(modelProvider);

    return Row(
      children: <Widget>[
        const SizedBox(width: 5), // Add some spacing
        ElevatedButton(
          onPressed: () {
            // Handle button click here
            debugPrint("MODEL BUTTON CLICKED! SELECTED VALUE "
                "$selectedValue = ${modellers[selectedValue]}");

            rSource(ref, "model_template");

            switch (model) {
              case "Tree":
                rSource(ref, "model_build_rpart");
              case "Forest":
                rSource(ref, "model_build_random_forest");
              default:
                debugPrint("NO ACTION FOR THIS BUTTON $model");
            }
          },
          child: const Text('Build'),
        ),
        const SizedBox(width: 5), // Add some spacing
        Row(
          children: modellers.asMap().entries.map((entry) {
            int index = entry.key;
            String label = entry.value;

            return buildRadioTile(index, label);
          }).toList(),
        ),
      ],
    );
  }

  Widget buildRadioTile(int value, String label) {
    return GestureDetector(
      onTap: () {
        selectRadio(value);
      },
      child: Row(
        children: [
          Radio(
            value: value,
            groupValue: selectedValue,
            onChanged: (int? newValue) {
              selectRadio(newValue!);
              ref.read(modelProvider.notifier).state = label;
              debugPrint("SET MODEL RADIO BUTTON TO $label");
            },
          ),
          Text(label),
        ],
      ),
    );
  }
}
