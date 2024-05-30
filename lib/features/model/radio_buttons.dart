/// Radio buttons to choose the model to build.
///
/// Time-stamp: <Sunday 2024-05-19 11:36:52 +1000 Graham Williams>
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
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

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rattle/features/model/tab.dart';

import 'package:rattle/provider/model.dart';
import 'package:rattle/r/source.dart';

class ModelRadioButtons extends ConsumerStatefulWidget {
  const ModelRadioButtons({Key? key}) : super(key: key);

  @override
  ConsumerState<ModelRadioButtons> createState() => ModelRadioButtonsState();
}

class ModelRadioButtonsState extends ConsumerState<ModelRadioButtons> {
  // List of modellers we support.

  List<String> modellers = [
    'Cluster',
    'Associate',
    'Tree',
    'Forest',
    'Boost',
    'Word Cloud',
  ];

  // Default selected valueas an idex into the modellers.

  int selectedValue = 3;

  void selectRadio(int value) {
    setState(() {
      selectedValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    String model = ref.watch(modelProvider);
    debugPrint("ModelRadioButtonsState build");

    return Row(
      children: <Widget>[
        const SizedBox(width: 5), // Add some spacing
        ElevatedButton(
          onPressed: () async {
            // Handle button click here
            debugPrint("MODEL BUTTON CLICKED! SELECTED VALUE "
                "$selectedValue = ${modellers[selectedValue]}");

            if (model != "Word Cloud") {
              rSource(ref, "model_template");
            }

            switch (model) {
              case "Tree":
                rSource(ref, "model_build_rpart");
              case "Forest":
                rSource(ref, "model_build_random_forest");
              case "Word Cloud":
                // context.read(pngPathProvider).state =
                File oldWordcloudFile = File(wordcloudImagePath);
                if (oldWordcloudFile.existsSync()) {
                  oldWordcloudFile.deleteSync();
                  debugPrint("old wordcloud file deleted");
                } else {
                  debugPrint("old wordcloud file not exists");
                }
                rSource(ref, "model_build_word_cloud");
              default:
                debugPrint("NO ACTION FOR THIS BUTTON $model");
            }
            if (model == "Word Cloud") {
              final file = File(wordcloudImagePath);
              while (true) {
                if (await file.exists()) {
                  debugPrint("file exists");
                  break;
                }
              }
              // toggle the state
              // ref.read(wordcloudBuildProvider.notifier).state =
              //     !ref.read(wordcloudBuildProvider.notifier).state;
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
    debugPrint("selectedValue is $selectedValue");
    return GestureDetector(
      onTap: () {
        selectRadio(value);
      },
      child: Row(
        children: [
          Radio(
            value: value,
            // use selectedValue here in the radio button
            groupValue: selectedValue,
            onChanged: (int? newValue) {
              selectRadio(newValue!);
              // this should be done when switching tab
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
