/// Session section.
//
// Time-stamp: <Monday 2025-01-06 15:20:25 +1100 Graham Williams>
//
/// Copyright (C) 2024, Togaware Pty Ltd
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
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
/// Authors: Kevin Wang
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';
import 'package:rattle/constants/spacing.dart';
import 'package:rattle/providers/session_control.dart';
import 'package:rattle/providers/settings.dart';
import 'package:rattle/settings/utils/save_image_viewer_app.dart';
import 'package:rattle/settings/widgets/image_viewer_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Session extends ConsumerWidget {
  const Session({super.key});

  /// Save ask on exit setting
  Future<void> saveAskOnExit(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('askOnExit', value);
  }

  /// Reset session control settings
  void resetSessionControl(WidgetRef ref) {
    ref.invalidate(askOnExitProvider);
    saveAskOnExit(true);

    final defaultApp = Platform.isWindows ? 'start' : 'open';
    ref.read(imageViewerSettingProvider.notifier).state = defaultApp;
    saveImageViewerApp(defaultApp);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final askOnExit = ref.watch(askOnExitProvider);

    return Column(
      children: [
        Row(
          children: [
            const Text(
              'Session',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            configRowGap,
            MarkdownTooltip(
              message: '''

              **Reset Session Control:** Tap here to reset to enable a confirmation
              popup when exiting the application.


              **Reset Image Viewer App:** Tap here to reset the Image Viewer App setting
              to the platform's default ("open" on Linux/MacOS, "start" on Windows).

              ''',
              child: ElevatedButton(
                onPressed: () => resetSessionControl(ref),
                child: const Text('Reset'),
              ),
            ),
          ],
        ),
        configRowGap,
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            MarkdownTooltip(
              message: '''

              **Session Control:** This setting determines whether a confirmation popup
              appears when the user tries to quit the application.

              - **ON**: A popup will appear asking the user to confirm quitting.

              - **OFF**: The application will exit immediately without a confirmation popup.

              The default setting is **ON**.

              ''',
              child: Row(
                children: [
                  const Text(
                    'Ask before exit',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  configRowGap,
                  Switch(
                    value: askOnExit,
                    onChanged: (value) {
                      ref.read(askOnExitProvider.notifier).state = value;
                      saveAskOnExit(value);
                    },
                  ),
                ],
              ),
            ),
            configRowGap,
            const ImageViewerTextField(),
          ],
        ),
        settingsGroupGap,
        const Divider(),
      ],
    );
  }
}
