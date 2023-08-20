/// Load data from the assets folder.
///
/// Authors: Zheyuan Xu

import 'package:flutter/services.dart' show rootBundle;

/// Load the text file at [path] from the assets folder
/// and return the contents as a string.

Future<String> loadMarkdownFromAsset(String path) async {
  return await rootBundle.loadString(path);
}
