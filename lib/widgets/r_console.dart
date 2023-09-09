/// A widget to run an interactive, writable, readable R console.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Saturday 2023-09-09 17:05:26 +1000 Graham Williams>
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

// STATUS 20230909: COPIED FROM XTERM EXAMPLE FOR NOW. IT CREATES A NEW WIDGET
// EACH TIME THE TAB IS ENTERED!!!! AND WOSRE STILL A NEW R PROCESS WITHOUT
// REMOVING THE OLD ONE :-) THEY ALL GO ON EXITTING THE APP.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_pty/flutter_pty.dart';
import 'package:universal_io/io.dart' show Platform;
import 'package:xterm/xterm.dart';

/// The R Console widget where the R subprocess runs and executes commands sent
/// to it and where the results are read from.

class RConsole extends StatefulWidget {
  const RConsole({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RConsoleState createState() => _RConsoleState();
}

class _RConsoleState extends State<RConsole> {
  final terminal = Terminal(
    maxLines: 10000,
  );

  final terminalController = TerminalController();

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
    pty = Pty.start(
      shell,
      columns: terminal.viewWidth,
      rows: terminal.viewHeight,
    );

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
  }

  @override
  Widget build(BuildContext context) {
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

          onSecondaryTapDown: (details, offset) async {
            final selection = terminalController.selection;
            if (selection != null) {
              final text = terminal.buffer.getText(selection);
              terminalController.clearSelection();
              await Clipboard.setData(ClipboardData(text: text));
            } else {
              final data = await Clipboard.getData('text/plain');
              final text = data?.text;
              if (text != null) {
                terminal.paste(text);
              }
            }
          },
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
