String cleanString(String txt) {
  // On moving to pty I was getting lots of escapes.

  txt = txt.replaceAll('', '');
  txt = txt.replaceAll('\r', '');
  txt = txt.replaceAll('[3m[38;5;246m', '');
  txt = txt.replaceAll('[?2004l', '');
  txt = txt.replaceAll('[39m[23m', '');
  txt = txt.replaceAll('[?2004h', '');
  txt = txt.replaceAll('[A', '');
  txt = txt.replaceAll('[C', '');
  txt = txt.replaceAll('[?25h', '');
  txt = txt.replaceAll('[K', '');
  txt = txt.replaceAll(RegExp(r'\[3.m'), '');

  return txt;
}
