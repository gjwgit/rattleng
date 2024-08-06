/// A widget to run an interactive, writable, readable R console.
///
/// Time-stamp: <Sunday 2024-08-04 20:14:08 +1000 Graham Williams>
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

library;

import 'package:flutter/material.dart';

import 'package:xterm/xterm.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/providers/pty.dart';
import 'package:rattle/providers/terminal.dart';

/// Widget to accept R commands and show results.

class RConsole extends ConsumerStatefulWidget {
  const RConsole({super.key});

  @override
  ConsumerState<RConsole> createState() => _RConsoleState();
}

class _RConsoleState extends ConsumerState<RConsole> {
  TerminalController terminalController = TerminalController();

  @override
  void initState() {
    super.initState();
    // This seems to be needed to initiate the pseudo terminal.
    ref.read(ptyProvider);
  }

  // There is no TerminalThemes for the black on white that I prefer and am
  // using for the app. The black on white does not stand out as much as a
  // Console white on black does. But the black on white is more in line with
  // the theme of the app.

  final blackOnWhite = TerminalTheme(
    cursor: const Color(0XFFAEAFAD),
    selection: const Color(0XFFAEAFAD).withOpacity(0.2),
    foreground: const Color(0XFF222222),
    background: const Color(0XFFFFFFFF),
    black: const Color(0XFF000000),
    red: const Color(0XFFCD3131),
    green: const Color(0XFF0DBC79),
    yellow: const Color(0XFFE5E510),
    blue: const Color(0XFF2472C8),
    magenta: const Color(0XFFBC3FBC),
    cyan: const Color(0XFF11A8CD),
    white: const Color(0XFFE5E5E5),
    brightBlack: const Color(0XFF666666),
    brightRed: const Color(0XFFF14C4C),
    brightGreen: const Color(0XFF23D18B),
    brightYellow: const Color(0XFFF5F543),
    brightBlue: const Color(0XFF3B8EEA),
    brightMagenta: const Color(0XFFD670D6),
    brightCyan: const Color(0XFF29B8DB),
    brightWhite: const Color(0XFFFFFFFF),
    searchHitBackground: const Color(0XFFFFFF2B),
    searchHitBackgroundCurrent: const Color(0XFF31FF26),
    searchHitForeground: const Color(0XFF000000),
  );

  @override
  Widget build(BuildContext context) {
    Terminal terminal = ref.watch(terminalProvider);

    return Scaffold(
      body: SafeArea(
        child: TerminalView(
          terminal,
          controller: terminalController,
          cursorType: TerminalCursorType.verticalBar,
          autofocus: true,
          backgroundOpacity: 1.0,
          padding: const EdgeInsets.all(8.0),
          textStyle: const TerminalStyle(fontFamily: 'RobotoMono'),
          theme: blackOnWhite,
        ),
      ),
    );
  }
}
