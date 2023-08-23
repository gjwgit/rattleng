import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart' show find;

/// Load the spcified dataset using the appropriate R script.

void loadDataset() {
  // Get the filename.

  final dsPathTextFinder = find.byKey(const Key('ds_path_text'));
  var dsPathText = dsPathTextFinder.evaluate().first.widget as TextField;
  String filename = dsPathText.controller?.text ?? '';

  if (filename == '') {
    print("RUN R SCRIPT load_demo_weather_aus_dataset.R;");
  } else {
    print('RUN R SCRIPT load_csv_dataset.R FILENAME -> "$filename";');
  }
}
