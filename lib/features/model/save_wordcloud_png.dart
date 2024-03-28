import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rattle/features/dataset/export_png.dart';

class SaveWordCloudButton extends StatelessWidget {
  final String wordCloudImagePath; // Path of the word cloud image

  SaveWordCloudButton({required this.wordCloudImagePath});

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
      child: Text('Save Word Cloud Image'),
    );
  }
}
