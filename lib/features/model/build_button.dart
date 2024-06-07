/// build button for model tab
//
// Time-stamp: <Thursday 2024-06-06 05:58:50 +1000 Graham Williams>
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
/// Authors: Graham Williams, Yixiang Yin

library;

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/features/model/tab.dart';
import 'package:rattle/provider/model.dart';
import 'package:rattle/provider/wordcloud/build.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/utils/timestamp.dart';

class ModelBuildButton extends ConsumerStatefulWidget {
  const ModelBuildButton({super.key});

  @override
  ConsumerState<ModelBuildButton> createState() => ModelBuildButtonState();
}

class ModelBuildButtonState extends ConsumerState<ModelBuildButton> {
  // List of modellers we support.

  List<String> modellers = [
    'Cluster',
    'Associate',
    'Tree',
    'Forest',
    'Boost',
    'WordCloud',
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
    debugPrint('current model tab is $model');
    debugPrint('ModelBuildButton build');

    return ElevatedButton(
      onPressed: () async {
        // Handle button click here
        debugPrint('MODEL BUTTON CLICKED for $model');

        if (model != 'Word Cloud') {
          rSource(ref, 'model_template');
        }

        switch (model) {
          case 'Tree':
            rSource(ref, 'model_build_rpart');
          case 'Forest':
            rSource(ref, 'model_build_random_forest');
          case 'Word Cloud':
            // context.read(pngPathProvider).state =
            // clean up the files from previous use
            File oldWordcloudFile = File(wordCloudImagePath);
            if (oldWordcloudFile.existsSync()) {
              oldWordcloudFile.deleteSync();
              debugPrint('old wordcloud file deleted');
            } else {
              debugPrint('old wordcloud file not exists');
            }
            File oldTmpFile = File(tmpImagePath);
            if (oldTmpFile.existsSync()) {
              oldTmpFile.deleteSync();
              debugPrint('old tmp file deleted');
            } else {
              debugPrint('old tmp file not exists');
            }
            rSource(ref, 'model_build_word_cloud');
          default:
            debugPrint('NO ACTION FOR THIS BUTTON $model');
        }
        if (model == 'Word Cloud') {
          final file = File(wordCloudImagePath);
          while (true) {
            if (await file.exists()) {
              debugPrint('file exists');
              break;
            }
          }
          // toggle the state to trigger rebuild
          debugPrint('build clicked on ${timestamp()}');
          ref.read(wordCloudBuildProvider.notifier).state = timestamp();
        }
      },
      child: const Text('Build'),
    );
  }
}
