/// Script section.
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
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rattle/constants/spacing.dart';
import 'package:rattle/providers/settings.dart';

class Script extends ConsumerWidget {
  const Script({super.key});

  /// Save strip comments setting.
  Future<void> saveStripComments(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('stripComments', value);
  }

  /// Reset session control settings
  void resetStripComments(WidgetRef ref) {
    ref.invalidate(stripCommentsProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stripComments = ref.watch(stripCommentsProvider);

    return Column(
      children: [
        Row(
          children: [
            const Text(
              'Script',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            configRowGap,
            MarkdownTooltip(
              message: '''

              **Reset Script Settings**
              
              Click to reset the script settings to their default values.
              This will restore the default behavior of including comments
              when saving scripts.

              ''',
              child: ElevatedButton(
                onPressed: () => resetStripComments(ref),
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

              **Strip Comments and Blank Lines**
              
              When **ON**, comments and blank lines will be removed from
              the script when saving to file. This produces cleaner R code
              that can be more easily compared with Rattle V5 output.
              
              When **OFF**, comments are preserved to maintain documentation
              and readability of the saved scripts.

              ''',
              child: Row(
                children: [
                  const Text(
                    'Strip comments',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  configRowGap,
                  Switch(
                    value: stripComments,
                    onChanged: (value) {
                      ref.read(stripCommentsProvider.notifier).state = value;
                      saveStripComments(value);
                    },
                  ),
                ],
              ),
            ),
            configRowGap,
          ],
        ),
        settingsGroupGap,
        const Divider(),
      ],
    );
  }
}
