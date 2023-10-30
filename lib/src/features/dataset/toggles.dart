/// A toggle button to nomrlaise variable names.
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

import 'package:rattle/src/widgets/delayed_tooltip.dart';

// This has to be a stateful widget otherwise the buttons don't visually toggle
// - i.e., the widget does not seem to get updated even though the values get
// updated.

class DatasetToggles extends StatefulWidget {
  const DatasetToggles({super.key});

  @override
  State<DatasetToggles> createState() => _DatasetTogglesState();
}

class _DatasetTogglesState extends State<DatasetToggles> {
  @override
  Widget build(BuildContext context) {
//    RattleModel rattle = Provider.of<RattleModel>(context, listen: false);

    return ToggleButtons(
      isSelected: const [true, true], //rattle.normalise, rattle.partition],
      onPressed: (int index) {
        setState(() {
          switch (index) {
            case 0:
            //rattle.setNormalise(!rattle.normalise);
            case 1:
            //rattle.setPartition(!rattle.partition);
          }
        });
      },
      children: const <Widget>[
        // NORMALISE
        DelayedTooltip(
          message: "The variables/column names are normalised by default.\n"
              "We use lowercase names separated by underscore.\n"
              "If you prefer not to normalise the names, turn this off.",
          child: Icon(Icons.auto_fix_high_outlined),
          // child: Icon(Icons.art_track),
          // child: Icon(Icons.ac_unit),
        ),
        // PARTITION
        DelayedTooltip(
          message: "The dataset is partitioned by default into 70/15/15.\n"
              "If you do not require it to be partitioned, turn this off.",
          child: Icon(Icons.horizontal_split),
          // child: Icon(Icons.assessment_outlined),
        ),
      ],
    );
  }
}
