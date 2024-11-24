/// A widget to run an interactive, writable, readable R console.
///
/// Time-stamp: <Wednesday 2024-11-20 17:08:38 +1100 Graham Williams>
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
import 'package:flutter/services.dart';
import 'package:rattle/providers/checked_r.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/utils/show_ok.dart';

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

    // Try initializing the pseudo terminal and catch any errors for Windows.

    try {
      ref.read(ptyProvider);
    } catch (e) {
      // If there is an error on Windows machine then show a popup message.

      WidgetsBinding.instance.addPostFrameCallback((_) {
        showOk(
          context: context,
          title: 'Console Error',
          content: '''

              R failed to start. Please check the **Console** tab for errors.

              ''',
        );
      });
    }

    // Check `R Version` is found in the Console (stdout) and only check it once
    // rather than every build by keeping track with a provider.

    Future.delayed(Duration(milliseconds: 3000), () {
      // Only proceed if `checkedRProvider` is false. We only want to check it
      // once, rather than every time we re-build the Console.

      if (!ref.read(checkedRProvider)) {
        // Update the provider state to prevent repeated execution.

        ref.read(checkedRProvider.notifier).state = true;

        final stdout = ref.watch(stdoutProvider);

        if (stdout.isNotEmpty && !stdout.contains('R version')) {
          showOk(
            context: context,
            title: 'R Error',
            content: '''

              R does not appear to have started. Please check the **Console**
              tab for errors.

              ''',
          );
        }
      }
    });
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
    // Retrieve the Terminal instance from the provider.
    final terminal = ref.watch(terminalProvider);

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onSecondaryTapDown: (details) {
            _showContextMenu(details.globalPosition, terminal);
          },
          child: TerminalView(
            terminal,
            controller: terminalController,
            autofocus: true,
            backgroundOpacity: 1.0,
            padding: const EdgeInsets.all(8.0),
            textStyle: const TerminalStyle(fontFamily: 'RobotoMono'),
            theme: blackOnWhite,
          ),
        ),
      ),
    );
  }

  /// Displays a context menu at the specified [position].
  ///
  /// The menu provides options for copying selected text or pasting text from
  /// the clipboard into the terminal.

  void _showContextMenu(Offset position, Terminal terminal) async {
    final selection = terminalController.selection;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    await showMenu(
      context: context,
      position: RelativeRect.fromRect(
        position &
            const Size(
              40,
              40,
            ), // Smaller Rect, makes the menu appear near the tap.
        Offset.zero & overlay.size,
      ),
      items: [
        // If there is selected text, show the "Copy" option.
        if (selection != null) ...[
          PopupMenuItem(
            child: const Text('Copy'),
            onTap: () async {
              final text = terminal.buffer.getText(selection);
              await Clipboard.setData(ClipboardData(text: text));
              terminalController.clearSelection();
            },
          ),
        ],
        // Always show the "Paste" option.
        PopupMenuItem(
          child: const Text('Paste'),
          onTap: () async {
            final data = await Clipboard.getData(Clipboard.kTextPlain);
            if (data != null) {
              terminal.paste(data.text!);
            }
          },
        ),
      ],
    );
  }
}
