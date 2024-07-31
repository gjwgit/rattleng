/// Record variable selection on the dataset tab
//
// Time-stamp: <Sunday 2024-07-21 07:33:03 +1000 Graham Williams>
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
/// Authors: Yixiang Yin

library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Role {
  input,
  target,
  risk,
  ident,
  ignore,
  ignoreAfterTransformed,
  weight,
}

// Define an extension on TemperatureType to override the toString method
extension RoleExtension on Role {
  String get displayString {
    switch (this) {
      case Role.input:
        return 'Input';
      case Role.target:
        return 'Target';
      case Role.risk:
        return 'Risk';
      case Role.ident:
        return 'Ident';
      case Role.ignore:
        return 'Ignore';
      default:
        return '';
    }
  }
}

bool remap(Role role, Role choice) {
  // ignoreAfterTransformed mapped to ignore in the gui
  if (role == Role.ignoreAfterTransformed) {
    if (choice == Role.ignore) {
      return true;
    }
  }
  return role == choice;
}

// These are roles to displayed in the GUI.
List<Role> choices = [
  Role.input,
  Role.target,
  Role.risk,
  Role.ident,
  Role.ignore,
  // 'Weight',
];

// ignore can be done by user or automatically.
// They have different roles: ignore or ignore_transformed
// map from variable to role
final rolesProvider = StateProvider<Map<String, Role>>((ref) => {});

// Custom getter to access the 'Target' value

// extension RolesProviderX on WidgetRef {
//   String get target {
//     final rolesMap = watch(rolesProvider);
//     // TODO yyx 20240723 Isn't it mapping from variable to role?

//     return rolesMap['Target'] ?? 'NULL';
//   }
// }
