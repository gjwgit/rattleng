/// This one keeps the previous shell but creates new one in same window.

/// A widget to run an interactive, writable, readable R console.
///
/// Time-stamp: <Saturday 2023-11-04 09:51:34 +1100 Graham Williams>
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
//
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
//import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

import 'package:flutter_pty/flutter_pty.dart';
import 'package:universal_io/io.dart' show Platform;
import 'package:xterm/xterm.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final terminalProvider = StateProvider<Terminal>((ref) {
  Terminal terminal = Terminal();

  return terminal;
});

final ptyProvider = StateProvider<Pty>((ref) {
  // Create a pseudo termminal provider.

  Terminal terminal = ref.watch(terminalProvider);
  Pty pty = Pty.start(shell);

  // Add a listener to the enclosing terminal.

  pty.output
      .cast<List<int>>()
      .transform(const Utf8Decoder())
      .listen(terminal.write);

  return pty;
});

/// Widget to accept R commands and show results.

class RConsole extends ConsumerStatefulWidget {
  const RConsole({Key? key}) : super(key: key);

  @override
  ConsumerState<RConsole> createState() => _RConsoleState();
}

class _RConsoleState extends ConsumerState<RConsole> {
  //Terminal(
  //  maxLines: 10000,
  //);

  TerminalController terminalController = TerminalController();

  late final Pty pty;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.endOfFrame.then(
      (_) {
        if (mounted) _startPty();
      },
    );
  }

  void _startPty() {
    print("CONSOLE: Start Pty");
    Terminal terminal = ref.read(terminalProvider);
    Pty pty = ref.read(ptyProvider);
    // pty = Pty.start(
    //   shell,
    //   columns: terminal.viewWidth,
    //   rows: terminal.viewHeight,
    // );

    print("$mounted");
    print("$pty.output");
    print("$pty.output.cast<List<int>>()");

    // pty.output
    //     .cast<List<int>>()
    //     .transform(const Utf8Decoder())
    //     .listen(terminal.write);

    pty.exitCode.then((code) {
      terminal.write('the process exited with exit code $code');
    });

    terminal.onOutput = (data) {
      pty.write(const Utf8Encoder().convert(data));
    };

    terminal.onResize = (w, h, pw, ph) {
      pty.resize(h, w);
    };
  }

  @override
  Widget build(BuildContext context) {
    Terminal terminal = ref.watch(terminalProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: TerminalView(
          terminal,
          controller: terminalController,
          autofocus: true,

          // Set the background to be black.

          backgroundOpacity: 1.0,

          // A buffer around the edge of the console.

          padding: const EdgeInsets.all(8.0),

          // This is how we can control the text size if desired.

          textScaleFactor: 1,
        ),
      ),
    );
  }
}

/// We are only interested in running R on whichever desktop.
///
/// Linux and MacOS desktops initiate R simply through the R command. Windows
/// does an R.exe.

String get shell {
  return Platform.isWindows ? 'R.exe' : 'R';
}
