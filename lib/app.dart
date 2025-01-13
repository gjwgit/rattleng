/// The root widget for the Rattle app.
///
/// Time-stamp: <Monday 2025-01-13 13:49:08 +1100 Graham Williams>
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
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
/// Authors: Graham Williams, Yixiang Yin

library;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:window_manager/window_manager.dart';

import 'package:rattle/home.dart';
import 'package:rattle/providers/script.dart';
import 'package:rattle/utils/is_desktop.dart';
import 'package:rattle/utils/timestamp.dart';
import 'package:rattle/widgets/close_dialog.dart';

// Add a key to reference [RattleHome] to access its method.

final GlobalKey<RattleHomeState> rattleHomeKey = GlobalKey<RattleHomeState>();

/// A widget for the root of the Rattle app encompassing the Rattle home widget.
///
/// This widget manages the application's lifecycle and handles cleanup
/// operations when the app is about to close. It uses [ConsumerStatefulWidget]
/// to interact with Riverpod providers and [WindowListener] to handle
/// window-related events, particularly for desktop platforms.

class RattleApp extends ConsumerStatefulWidget {
  const RattleApp({super.key});

  @override
  ConsumerState<RattleApp> createState() => _RattleAppState();
}

class _RattleAppState extends ConsumerState<RattleApp> with WindowListener {
  /// Initializes the state and sets up window management.

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _init();
  }

  /// Removes this object as a window listener when the widget is disposed.

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  /// Initializes window management settings.

  void _init() async {
    // Prevent the window from closing by default

    if (isDesktop) await windowManager.setPreventClose(true);

    setState(() {
      null;
    });

    // Initialise the template variables in the R script.

    PackageInfo info = await PackageInfo.fromPlatform();
    ref.read(scriptProvider.notifier).update(
          (state) => state
              .replaceAll('VERSION', info.version)
              .replaceAll('TIMESTAMP', 'Timestamp ${timestamp()}'),
        );
  }

  /// Handle the window close event.
  ///
  /// This method is called when the user attempts to close the window.  It
  /// shows a confirmation dialog and performs cleanup if the user confirms.

  @override
  void onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose) {
      _showCloseConfirmationDialog();
    }
  }

  void _showCloseConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const CloseDialog();
      },
    );
  }

  /// Build the widget tree for the Rattle app.

  @override
  Widget build(BuildContext context) {
    return RattleHome(key: rattleHomeKey);
  }
}
