/// A provider of the pseudo terminal running R.
///
/// Time-stamp: <Saturday 2023-11-04 15:26:20 +1100 Graham Williams>
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU General Public License as published by the Free Software
// Foundation, either version 3 of the License, or (at your option) any later
// version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program.  If not, see <https://www.gnu.org/licenses/>.
///
/// Authors: Graham Williams

import 'dart:convert';

import 'package:flutter_pty/flutter_pty.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_io/io.dart' show Platform;
import 'package:xterm/xterm.dart';

import 'package:rattle/provider/terminal.dart';

final ptyProvider = StateProvider<Pty>((ref) {
  // Create a pseudo termminal provider.

  Terminal terminal = ref.watch(terminalProvider);
  Pty pty = Pty.start(shell);

  // Options
  //   columns: terminal.viewWidth,
  //   rows: terminal.viewHeight,

  // Add a listener to the enclosing terminal.

  pty.output
      .cast<List<int>>()
      .transform(const Utf8Decoder())
      .listen(terminal.write);

  pty.exitCode.then((code) {
    terminal.write('the process exited with exit code $code');
  });

  terminal.onOutput = (data) {
    pty.write(const Utf8Encoder().convert(data));
  };

  terminal.onResize = (w, h, pw, ph) {
    pty.resize(h, w);
  };

  return pty;
});

/// We are only interested in running R on whichever desktop.
///
/// Linux and MacOS desktops initiate R simply through the R command. Windows
/// does an R.exe.

String get shell {
  return Platform.isWindows ? 'R.exe' : 'R';
}
