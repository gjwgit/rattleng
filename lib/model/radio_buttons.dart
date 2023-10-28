/// Radio buttons to choose the model to build.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
// Licensed under the GNU General Public License, Version 3 (the "License");
///
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


class ModelRadioButtons extends StatefulWidget {
  const ModelRadioButtons({Key? key}) : super(key: key);

  @override
  ModelRadioButtonsState createState() => ModelRadioButtonsState();
}

class ModelRadioButtonsState extends State<ModelRadioButtons> {
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
    return Row(
      children: <Widget>[
        const SizedBox(width: 5), // Add some spacing
//        Consumer<RattleModel>(
//          builder: (context, rattle, child) {
//            return
        ElevatedButton(
          onPressed: () {
            // Handle button click here
            debugPrint("MODEL BUTTON CLICKED! SELECTED VALUE "
                "$selectedValue = ${modellers[selectedValue]}");

//                rSource("model_template", rattle);

//                switch (rattle.model) {
//                  case "Tree":
//                    rSource("model_build_rpart", rattle);
//                  case "Forest":
//                    rSource("model_build_random_forest", rattle);
//                  default:
//                    debugPrint("NO ACTION FOR THIS BUTTON ${rattle.model}");
//                }
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
      child: //Consumer<RattleModel>(
//        builder: (context, rattle, child) {
//          return
          Row(
        children: [
          Radio(
            value: value,
            groupValue: selectedValue,
            onChanged: (int? newValue) {
              selectRadio(newValue!);
//                  rattle.setModel(label);
              debugPrint("SET MODEL RADIO BUTTON TO $label");
            },
          ),
          Text(label),
        ],
      ),
    );
  }
}
