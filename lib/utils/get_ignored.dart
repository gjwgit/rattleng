/// Query the roles provider to return the list of ignored variables.
//
// Time-stamp: <Sunday 2024-09-08 12:16:31 +1000 Graham Williams>
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
/// Authors: Graham Williams

library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/providers/vars/roles.dart';

List<String> getIgnored(WidgetRef ref) {
  // The rolesProvider lists the roles for the different variables which we need
  // to know for parsing the R scripts.

  Map<String, Role> roles = ref.read(rolesProvider);

  // Extract the ignored variable from the rolesProvider.

  List<String> ignored = [];
  roles.forEach((key, value) {
    if (value == Role.ignore) {
      ignored.add(key);
    }
  });

  return ignored;
}
