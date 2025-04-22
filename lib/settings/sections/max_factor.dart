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
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';

import 'package:rattle/providers/cleanse.dart';
import 'package:rattle/widgets/number_field.dart';

class MaxFactor extends ConsumerWidget {
  const MaxFactor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController _maxFactorController = TextEditingController();

    return MarkdownTooltip(
      message: '''

            **Max Factor:** Specify here the maximum number of unique values for
            a character column in the dataset for which when the **Cleanse**
            toggle, when enabled, will automatically convert to a **factor**.

            ''',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          NumberField(
            label: 'Max Factor',
            key: const Key('max_factor_settings'),
            controller: _maxFactorController,
            inputFormatter: FilteringTextInputFormatter.digitsOnly,
            validator: (value) => validateInteger(value, min: 1),
            stateProvider: maxFactorProvider,
            sharedPrefsKey: 'maxFactor',
          ),
        ],
      ),
    );
  }
}
