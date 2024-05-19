import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rattle/features/dataset/export_png.dart';

class SaveWordcloudButton extends StatelessWidget {
  final String wordcloudImagePath; // Path of the word cloud image

  SaveWordcloudButton({required this.wordcloudImagePath});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        String? pathToSave = await selectFile();
        if (pathToSave != null) {
          // copy file
          await File(wordcloudImagePath).copy(pathToSave);
        }
      },
      child: Text('Save Word Cloud Image'),
    );
  }
}
