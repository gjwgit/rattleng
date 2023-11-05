String rStripComments(String txt) {
  List<String> lines = txt.split('\n');
  List<String> result = [];

  for (int i = lines.length - 1; i >= 0; i--) {
    if (!lines[i].startsWith('#')) {
      result.add(lines[i]);
    }
  }

  return result.join('\n');
}
