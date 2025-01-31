//  Get the first ident variable from the rolesProvider.
// Time-stamp: <Wednesday 2025-01-15 16:25:50 +1100 Graham Williams>
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

// ignore_for_file: check-unused-files

library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/providers/vars/roles.dart';

String getIdent(WidgetRef ref) {
  Map<String, Role> roles = ref.read(rolesProvider);

  // Extract the first identifier variable from the rolesProvider.

  final ident = roles.entries
      .firstWhere(
        (entry) => entry.value == Role.ident,
        orElse: () => MapEntry('', Role.ignore),
      )
      .key;

  return ident;
}
