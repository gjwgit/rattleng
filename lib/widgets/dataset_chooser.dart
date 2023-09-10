import 'package:flutter/material.dart';

import 'package:rattle/widgets/file_picker_ds.dart';

class DatasetChooser extends StatefulWidget {
  const DatasetChooser({super.key});

  @override
  State<DatasetChooser> createState() => _DatasetChooserState();
}

class _DatasetChooserState extends State<DatasetChooser> {
  String dataName = "";

  // A controller for the text field so it can be updated programmatically.

  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Some fixed space so the widgets aren't crowded.

        const SizedBox(width: 5),

        // Widget to select the dataset filename.

        const FilePickerDS(),

        // Some fixed space so the widgets aren't crowded.

        const SizedBox(width: 5),

        // A text field to display the selected dataset name.

        Expanded(
          child: TextField(
            key: const Key('ds_path_text'),
            controller: _textController,
            decoration: const InputDecoration(
              hintText: 'Path to dataset file.',
            ),
          ),
        ),
      ],
    );
  }
}
