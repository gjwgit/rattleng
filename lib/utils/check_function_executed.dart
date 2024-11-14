/// Check if the function has been executed.
//
// Time-stamp: <Friday 2024-10-25 08:27:46 +1100 Graham Williams>
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
/// Authors: Zheyuan Xu

library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/temp_dir.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/utils/image_exists.dart';

bool checkFunctionExecuted(
    WidgetRef ref, List checkCommands, List checkImages,) {
  String stdout = ref.watch(stdoutProvider);

  for (String item in checkCommands) {
    if (!stdout.contains(item)) {
      return false;
    }
  }
  for (String imagePath in checkImages) {
    String image = '$tempDir/$imagePath';
    if (!imageExists(image)) {
      return false;
    }
  }

  return true;
}
