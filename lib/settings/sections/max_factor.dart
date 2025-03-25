/// Max factor section.
//
// Time-stamp: <Tuesday 2025-03-25 16:52:43 +1100 Graham Williams>
//
/// Copyright (C) 2025, Togaware Pty Ltd
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
/// Authors: Zheyuan Xu
library;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rattle/constants/spacing.dart';
import 'package:rattle/constants/style.dart';
import 'package:rattle/providers/cleanse.dart';
import 'package:rattle/widgets/repeat_button.dart';

class MaxFactor extends ConsumerWidget {
  const MaxFactor({super.key});

  // Save the "Max Factor" state to SharedPreferences.

  Future<void> _saveMaxFactor(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('maxFactor', value);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int maxFactor = ref.watch(maxFactorProvider);

    return MarkdownTooltip(
      message: '''

            **Max Factor:** Specify here the maximum number of unique values for
            a character column in the dataset for which when the **Cleanse**
            toggle, when enabled, will automatically convert to a **factor**.

            ''',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Max Factor',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          configRowGap,
          RepeatButton(
            child: const Icon(Icons.remove),
            onPressed: () {
              final newValue = maxFactor - 1;
              ref.read(maxFactorProvider.notifier).state = newValue;
              _saveMaxFactor(newValue);
            },
          ),
          Text(
            ' $maxFactor ',
            style: normalTextStyle,
          ),
          RepeatButton(
            child: const Icon(Icons.add),
            onPressed: () {
              final newValue = maxFactor + 1;
              ref.read(maxFactorProvider.notifier).state = newValue;
              _saveMaxFactor(newValue);
            },
          ),
        ],
      ),
    );
  }
}
