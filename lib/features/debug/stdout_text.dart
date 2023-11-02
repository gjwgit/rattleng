/// A text widget showing the stdout from the R process.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
// Time-stamp: <Wednesday 2023-11-01 08:41:55 +1100 Graham Williams>
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

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/provider/stdout.dart';
import 'package:rattle/constants/app.dart';

/// Create a stdout text viewer that can scroll the text of stdout.
///
/// The contents is intialised from rattle state's stdout.

class StdoutText extends ConsumerWidget {
  const StdoutText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Builder(
        builder: (BuildContext context) {
          String stdout = ref.watch(stdoutProvider);

          return SelectableText(
            "STDOUT from the R Process:\n"
            "$stdout",
            style: monoSmallTextStyle,
          );
        },
      ),
    );
  }
}
