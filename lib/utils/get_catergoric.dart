/// <DESCRIPTION>
//
// Time-stamp: <Saturday 2024-09-21 15:40:38 +1000 Graham Williams>
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
/// Authors: <AUTHORS>

library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/providers/stdout.dart';
import 'package:rattle/providers/vars/roles.dart';
import 'package:rattle/providers/vars/types.dart';
import 'package:rattle/r/extract_large_factors.dart';

List<String> getCategoric(
  WidgetRef ref,
) {
  // The typesProvider lists the types for the different variables which we
  // need to know for parsing the R scripts.

  Map<String, Type> roles = ref.read(typesProvider);

  String stdout = ref.watch(stdoutProvider);

  List<String> largeFactors = extractLargeFactors(stdout);

  List<String> rtn = [];
  roles.forEach((key, value) {
    if (value == Type.categoric && (!largeFactors.contains(key))) {
      // Omit variables which are set as ignore.

      if (ref.read(rolesProvider.notifier).state[key] != Role.ignore) {
        rtn.add(key);
      }
    }
  });

  return rtn;
}
