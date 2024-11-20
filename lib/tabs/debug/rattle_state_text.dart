/// A text widget showing the current rattle state.
///
/// Time-stamp: <Thursday 2024-11-21 08:19:17 +1100 Graham Williams>
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
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program.  If not, see <https://www.gnu.org/licenses/>.
///
/// Authors: Graham Williams, Yixiang Yin
library;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/style.dart';
import 'package:rattle/providers/cleanse.dart';
import 'package:rattle/providers/group_by.dart';
import 'package:rattle/providers/imputed.dart';
import 'package:rattle/providers/meta_data.dart';
import 'package:rattle/providers/model.dart';
import 'package:rattle/providers/normalise.dart';
import 'package:rattle/providers/partition.dart';
import 'package:rattle/providers/path.dart';
import 'package:rattle/providers/vars/roles.dart';
import 'package:rattle/providers/script.dart';
import 'package:rattle/providers/selected.dart';
import 'package:rattle/providers/selected2.dart';
import 'package:rattle/providers/settings.dart';
import 'package:rattle/providers/status.dart';
import 'package:rattle/providers/stderr.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/providers/vars/types.dart';
import 'package:rattle/utils/count_lines.dart';
import 'package:rattle/utils/get_ignored.dart';
import 'package:rattle/utils/get_risk.dart';
import 'package:rattle/utils/get_target.dart';

class RattleStateText extends ConsumerWidget {
  const RattleStateText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialise the state variables used here.

    String groupBy = ref.watch(groupByProvider);
    String path = ref.watch(pathProvider);
    String status = ref.watch(statusProvider);
    String script = ref.watch(scriptProvider);
    String stderr = ref.watch(stderrProvider);
    String stdout = ref.watch(stdoutProvider);
    String model = ref.watch(modelProvider);
    String selected = ref.watch(selectedProvider);
    String selected2 = ref.watch(selected2Provider);
    String imputed = ref.watch(imputedProvider);
    String theme = ref.watch(settingsGraphicThemeProvider);

    bool cleanse = ref.watch(cleanseProvider);
    bool normalise = ref.watch(normaliseProvider);
    bool partition = ref.watch(partitionProvider);

    // The rolesProvider lists the roles for the different variables which we
    // need to know for parsing the R scripts. The typesProvider is a record of
    // the data types of each variable.

    Map<String, Role> roles = ref.watch(rolesProvider);
    Map<String, Type> types = ref.watch(typesProvider);
    Map<String, dynamic> metaData = ref.watch(metaDataProvider);

    // We will print out the roles and types so format them.

    String role = roles.toString();
    role = role.replaceAll(',', '\n${" " * 13}');

    String type = types.toString();
    type = type.replaceAll(',', '\n${" " * 13}');

    String meta = metaData.toString();
    meta = meta.replaceAll('},', '},\n${" " * 13}');
    meta = meta.replaceAll(': {', ':\n${" " * 18}');
    meta = meta.replaceAll(', min:', ',\n${" " * 18}min:');
    meta = meta.replaceAll(', unique:', ',\n${" " * 18}unique:');

    String ignored = getIgnored(ref).join('\n${" " * 13}');

    return SingleChildScrollView(
      child: Builder(
        builder: (BuildContext context) {
          return SelectableText(
            'STATUS:      $status\n'
            'SCRIPT:      ${countLines(script)} lines\n'
            'STDOUT:      ${countLines(stdout)} lines\n'
            'STDERR:      ${countLines(stderr)} lines\n'
            'PATH:        $path\n'
            'CLEANSE:     $cleanse\n'
            'NORMALISE:   $normalise\n'
            'PARTITION:   $partition\n'
            'THEME:       $theme\n'
            'META DATA:   $meta\n'
            '\n**DEPRECATED** ROLES AND TYPES ARE BEING DEPRECATED.\n\n'
            'ROLES:       $role\n'
            'TYPES:       $type\n\n'
            'TARGET:      ${getTarget(ref)}\n'
            'RISK:        ${getRisk(ref)} \n'
            'IDENTIFIERS: \$identifiers \n'
            'IGNORE:      $ignored\n'
            'SELECTED:    $selected\n'
            'SELECTED2:   $selected2\n'
            'GROUP BY:    $groupBy\n'
            'IMPUTED:     $imputed\n'
            'MODEL:       $model\n',
            style: monoSmallTextStyle,
          );
        },
      ),
    );
  }
}
