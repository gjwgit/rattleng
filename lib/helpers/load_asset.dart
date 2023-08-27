/// Load data from the assets folder.
///
/// Authors: Zheyuan Xu, Graham Williams

import 'package:flutter/services.dart' show rootBundle;

/// Load the text file at [path] from the assets folder
/// and return the contents as a string.

Future<String> loadAsset(String path) async {
  return await rootBundle.loadString(path);
}
