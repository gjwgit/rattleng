/// Identify a target variable.
//
// Time-stamp: "Monday 2024-12-16 08:18:30 +1100 Graham Williams"
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

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/providers/meta_data.dart';
import 'package:rattle/providers/vars/roles.dart';

String getTarget(WidgetRef ref) {
  // The rolesProvider lists the roles for the different variables which we
  // need to know for parsing the R scripts. Roles get updated when user
  // updates the roles in the UI.

  Map<String, Role> roles = ref.watch(rolesProvider);

  // Extract the target variable from the rolesProvider.

  String target = 'NULL';
  roles.forEach((key, value) {
    if (value == Role.target) {
      target = key;
    }
  });

  if (target == 'NULL') {
    Map<String, dynamic> metaData = ref.watch(metaDataProvider);

    String candidateTarget = 'NULL';

    // Initialize minLevels to null initially.

    int? minLevels;

    // Iterate through metadata to find factor variables.

    metaData.forEach((varName, varData) {
      // Ensure varData is a Map and contains 'datatype' and 'unique'.

      if (varData is Map &&
          varData.containsKey('datatype') &&
          varData.containsKey('unique')) {
        String dataType = varData['datatype'].first ?? '';
        dynamic uniqueData = varData['unique'];

        // Check if it's a factor/categoric type.

        if (dataType.contains('factor') ||
            dataType.contains('character') ||
            dataType.contains('ordered')) {
          // Ensure 'unique' is a list and not empty.

          if (uniqueData is List && uniqueData.isNotEmpty) {
            // Attempt to parse the unique count.

            int? uniqueCount = int.tryParse(uniqueData[0].toString());

            if (uniqueCount != null) {
              // If this is the first suitable variable found, initialize minLevels.

              if (minLevels == null) {
                minLevels = uniqueCount;
                candidateTarget = varName;
              } else {
                // Otherwise, compare with the current minimum.

                if (uniqueCount <= minLevels!) {
                  minLevels = uniqueCount;
                  candidateTarget = varName;
                }
              }
            }
          }
        }
      }
    });

    // Return the best candidate found from metadata, or 'NULL' if none.
    // This replaces the stdout parsing logic.

    if (candidateTarget != 'NULL' && roles[candidateTarget] != Role.ident) {
      return candidateTarget;
    }
  }

  // If target was already set by rolesProvider, return it here.
  // If the metadata search above didn't find anything, 'NULL' is returned from there.

  return target;
}
