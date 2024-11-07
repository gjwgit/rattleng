/// Widget to configure the dataset: button, path, clear, and toggles.
/// 
/// Copyright (C) 2023, Togaware Pty Ltd.
/// 
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Friday 2024-06-07 13:59:17 +1000 Graham Williams>
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

import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'package:flutter/material.dart';

import 'package:rattle/features/dataset/button.dart';
import 'package:rattle/features/dataset/clear_text_field.dart';
import 'package:rattle/features/dataset/text_field.dart';
import 'package:rattle/features/dataset/toggles.dart';
import 'package:rattle/providers/role.dart';
import 'package:rattle/widgets/choice_chip_tip.dart';

const double widthSpace = 5;

/// The dataset config allows selection and tuning of the data for Rattle.
/// 
/// The widget consists of a button to allow picking the dataset and a text
/// field where the dataset path or name is displayed or entered by the user
/// typing it in.
/// 
/// This is a StatefulWidget to record the name of the chosen dataset. TODO THE
/// DATASET NAME MAY NEED TO BE PUSHED HIGHER FOR ACCESS FROM OTHER PAGES.

class DatasetConfig extends ConsumerStatefulWidget {
  const DatasetConfig({super.key});

  @override
  ConsumerState<DatasetConfig> createState() => _DatasetConfigState();
}

class _DatasetConfigState extends ConsumerState<DatasetConfig> {
  
  // A controller for the text field so it can be updated programmatically.
  // 
  // final TextEditingController _textController = TextEditingController();

    Map<String, String> rolesOption = {
    'IGNORE': '''

      Ignore this dataset during analysis.

      ''',
    'INPUT': '''

      Include this dataset for input during analysis.

      ''',
  };

  @override
  Widget build(BuildContext context) {
        String role = ref.read(roleProvider.notifier).state;

    return Column(
      children: [
        Row(
          children: [
            // Some fixed space so the widgets aren't crowded.

            const SizedBox(width: widthSpace),

            // Widget to select the dataset filename.

            const DatasetButton(),

            SizedBox(width: widthSpace),

            // A text field to display the selected dataset name.

            const DatasetTextField(),

            // Clear the textfield entry.

            const DatasetClearTextField(),

            SizedBox(width: widthSpace),

            // Toggles to choose what to do on loading the dataset.

            const DatasetToggles(),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            // Space between the two rows.

            const SizedBox(width: widthSpace),

            // ChoiceChipTip for selecting options like 'IGNORE' and 'INPUT'.

            ChoiceChipTip<String>(
              options: rolesOption.keys.toList(),
              selectedOption: role,
              tooltips: rolesOption,
              onSelected: (chosen) {
                setState(() {
                       if (chosen != null) {
                    role = chosen;
                    ref.read(roleProvider.notifier).state = chosen;
                  }
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
