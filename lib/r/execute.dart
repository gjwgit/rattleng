// DON'T USE THIS FOR NOW. WHILE THE EXECUTE IN R WORKSTHE RESULT DOESE NOT GET
// INTO THE STDOUT UNTIL LATER ON AND SO I CAN'T IMMEDIATELY CHECK THE
// VALUE. NEEDS TO BE FIXED.

/// R Scripts: Support for running an R command.
///
/// Time-stamp: <Wednesday 2024-07-31 06:49:59 +1000 Graham Williams>
///
/// Copyright (C) 2023, Togaware Pty Ltd.
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
// ttt
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

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/providers/pty.dart';
import 'package:rattle/utils/update_script.dart';

/// Run the R [code] and append to the [rattle] script.

void rExecute(WidgetRef ref, String code) {
  debugPrint("R EXECUTE:\t\t'$code'");

  // Add the code to the script provider so it will be displayed in the script
  // tab.

  updateScript(
    ref,
    "\n${'#' * 72}\n## -- Extra Code --\n${'#' * 72}"
    '\n$code}\n',
  );

  ref.read(ptyProvider).write(const Utf8Encoder().convert(code));
}
