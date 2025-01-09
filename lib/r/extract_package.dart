// Function to parse the input text

Map<String, List<String>> parsePackage(String text) {
  final Map<String, List<String>> datasetsMap = {};
  final lines = text.split('\n'); // Split input into lines
  String? currentPackage; // To store the current package name

  for (var line in lines) {
    line = line.trim(); // Remove leading and trailing spaces
    if (line.startsWith(r'$')) {
      // If line starts with $, it's a package name
      currentPackage =
          line.substring(1); // Remove the $ and store the package name
      datasetsMap[currentPackage] = []; // Initialize an empty list for datasets
    } else if (line.contains('"') && currentPackage != null) {
      // If line contains dataset names (quoted), extract them separately
      final regex = RegExp(r'"(.*?)"'); // Regex to match each quoted string
      final matches = regex.allMatches(line);
      for (var match in matches) {
        // debugPrint("dataset is ${match.group(1)!}");
        // Add each match as a separate dataset
        datasetsMap[currentPackage]?.add(match.group(1)!);
      }
    }
  }

  return datasetsMap;
}
