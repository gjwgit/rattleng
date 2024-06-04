import 'dart:io';

import 'package:flutter/material.dart';

import 'package:rattle/features/model/wordcloud/select_file.dart';

class WordCloudSaveButton extends StatelessWidget {
  // Path to the word cloud temp image file.
  final String wordCloudImagePath;

  const WordCloudSaveButton({super.key, required this.wordCloudImagePath});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        String? pathToSave = await selectFile();
        if (pathToSave != null) {
          // Copy generated image from /tmp to user's location.
          await File(wordCloudImagePath).copy(pathToSave);
        }
      },
      child: const Text('Save Word Cloud Image'),
    );
  }
}
