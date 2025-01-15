/// Validate partition total when pressing cancel button.
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rattle/providers/settings.dart';
import 'package:rattle/settings/utils/invalid_partition_warning.dart';

void handleCancelButton(BuildContext context, WidgetRef ref) {
  final train = ref.read(partitionTrainProvider);
  final valid = ref.read(partitionTuneProvider);
  final test = ref.read(partitionTestProvider);
  final total = train + valid + test;

  if (total != 100) {
    showInvalidPartitionWarning(context);
  } else {
    Navigator.of(context).pop();
  }
}
