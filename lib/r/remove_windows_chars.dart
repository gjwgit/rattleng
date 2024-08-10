String removeWindowsChars(String txt) {
  return txt.replaceAll(RegExp(r'\[\d{1,2}C'), '');
}
