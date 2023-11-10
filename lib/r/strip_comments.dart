String rStripComments(String txt) {
  List<String> lines = txt.split('\n');
  List<String> result = [];

  for (int i = 0; i < lines.length; i++) {
    // Keep only those lines that are not comments and not empty.

    if (!lines[i].startsWith('#') && lines[i].isNotEmpty) {
      // Strip comments at the end of the line.

      result.add(lines[i].replaceAll(RegExp(r' *#.*'), ''));
    }
  }

  // Add newlines at the beginning and the end to ensure the commands are on
  // lines of their own.

  return "\n${result.join('\n')}\n";
}
