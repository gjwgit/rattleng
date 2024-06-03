import 'dart:io';

import 'package:flutter/material.dart';

import 'package:rattle/features/model/wordcloud/select_file.dart';

class WordCloudSaveButton extends StatelessWidget {
  final String wordCloudImagePath; // Path of the word cloud image

  const WordCloudSaveButton({required this.wordCloudImagePath});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        String? pathToSave = await selectFile();
        if (pathToSave != null) {
          // copy file
          await File(wordCloudImagePath).copy(pathToSave);
        }
      },
      child: const Text('Save Word Cloud Image'),
    );
  }
}
