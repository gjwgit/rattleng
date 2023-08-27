/// A file picker to choose the dataset for analysis.
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

import 'package:file_picker/file_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart' show find;

class FilePickerDS extends StatefulWidget {
  const FilePickerDS({Key? key}) : super(key: key);

  @override
  FilePickerDSState createState() => FilePickerDSState();
}

class FilePickerDSState extends State<FilePickerDS> {
  String? _directoryPath;
  List<PlatformFile>? _paths;

  void _pickFiles() async {
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        //type: _pickingType,
        allowMultiple: false,
        // ignore: avoid_print
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: ["csv", "tsv", "arff", "rdata"],
        dialogTitle: "Please Select Your Dataset File",
      ))
          ?.files;
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() {
      _directoryPath =
          _paths != null ? _paths!.map((e) => e.path).toString() : null;

      final dsPathTextFinder = find.byKey(const Key('ds_path_text'));
      var dsPathText = dsPathTextFinder.evaluate().first.widget as TextField;

      // 20230821 gjw A little ugly using `?.` and ?? to deal with the nullable
      // differences between the Strings. It works.

      String filename = _directoryPath ?? '';

      // The filename has brackets around it. Not sure why!

      if (filename.isNotEmpty &&
          filename.startsWith("(") &&
          filename.endsWith(")")) {
        filename = filename.substring(1, filename.length - 1);
      }

      dsPathText.controller?.text = filename;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: const Key("file_picker_ds"),
      width: 120,
      child: ElevatedButton(
        onPressed: () => _pickFiles(),
        //shape: StadiumBorder(),
        //foregroundColor: Colors.white,
        //child: const Icon(Icons.description)),
        child: const Text("Filename:"),
      ),
    );
  }
}
