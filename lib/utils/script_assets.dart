import 'package:flutter/services.dart' show rootBundle;

/// Load and cache the contents of the R script files assets.
///
/// This is expected to happen when the app starts. Strip the top copyright off
/// of the scripts to avoid storing too much unnecessarily. But keep comments
/// otherwise as the code goes into **Scripts**. Then in rSource() we will strip
/// other comments to pass it on to the Console.

class ScriptAssets {
  static final Map<String, String> _assets = {};

  static Future<void> preloadAssets(List<String> assetFilenames) async {
    for (var filename in assetFilenames) {
      final content = await rootBundle.loadString('assets/r/$filename');
      final key = filename.replaceAll('.R', '');
      _assets[key] = content;
    }
  }

  static String getAsset(String key) {
    return _assets[key] ?? '';
  }

  static bool assetsLoaded() {
    return _assets.isNotEmpty;
  }
}
