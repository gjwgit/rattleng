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
            File oldWordcloudFile = File(wordCloudImagePath);
            if (oldWordcloudFile.existsSync()) {
              oldWordcloudFile.deleteSync();
              debugPrint('old wordcloud file deleted');
            } else {
              debugPrint('old wordcloud file not exists');
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
