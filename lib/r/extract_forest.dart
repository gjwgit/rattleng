/// Utility to extract the latest random forest from R log.
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Sunday 2024-06-09 09:27:07 +1000 Graham Williams>
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
/// Authors: Graham Williams, Zheyuan Xu
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/providers/forest.dart';
import 'package:rattle/providers/tree_algorithm.dart';
import 'package:rattle/r/extract.dart';
import 'package:rattle/utils/timestamp.dart';

String _basicTemplate(
  String log,
  WidgetRef ref,
) {
  AlgorithmType forestAlgorithm =
      ref.read(algorithmForestProvider.notifier).state;

  String hd = forestAlgorithm == AlgorithmType.traditional
      ? 'Summary of the Random Forest model for Classification'
      : 'Summary of the Conditional Forest model for Classification';
  String md = forestAlgorithm == AlgorithmType.traditional
      ? "(built using 'randomForest'):"
      : "(built using 'cforest'):";
  final String fm = forestAlgorithm == AlgorithmType.traditional
      ? rExtract(log, '> print(form)')
      : rExtract(log, '> print(model_conditionalForest)');
  final String pr = forestAlgorithm == AlgorithmType.traditional
      ? rExtract(log, '> print(model_randomForest)')
      : '';
  final String pe = forestAlgorithm == AlgorithmType.traditional
      ? rExtract(
          log,
          '+                 as.numeric(model_randomForest\$predicted))',
        )
      : '';
  final String ts = timestamp();

  String result = '';

  if (pr != '') {
    result = '$hd $md\n\nFormula: $fm\n$pr \n$pe\n\nRattle timestamp: $ts';
  }
  if (fm != '') result = '$hd $md\n\nFormula: $fm\n\nRattle timestamp: $ts';

  return result;
}

/// Extract from the R [log] lines of output from the random forest.

String rExtractForest(
  String log,
  WidgetRef ref,
) {
  AlgorithmType forestAlgorithm =
      ref.read(algorithmForestProvider.notifier).state;

  String extract = _basicTemplate(log, ref);

  extract = extract.replaceAll('Call:\n', '');

  if (forestAlgorithm == AlgorithmType.traditional) {
    // Nicely format the call to randomForest.

    extract = extract.replaceAllMapped(
      RegExp(
        r'\n (randomForest\(.*?)\)',
        multiLine: true,
        dotAll: false,
      ),
      (match) {
        // The first group is then the whole randomForest(...) call.

        String txt = match.group(1) ?? '';

        txt = txt.replaceAll('\n', '');
        txt = txt.replaceAll(RegExp(r',\s*m'), ', m');

        txt = txt.replaceAllMapped(
          RegExp(r'(\w+)\s*=\s*([^,]+),'),
          (match) {
            return '\n    ${match.group(1)}=${match.group(2)},';
          },
        );

        txt = txt.replaceAll(' = ', '=');

        return '\n$txt\n)\n';
      },
    );

    extract = extract.replaceAll(
      '\nConfusion matrix:\n',
      '\n\nConfusion matrix:\n\n',
    );

    extract = extract.replaceAll('\nArea under', '\n\nArea under');
  } else if (forestAlgorithm == AlgorithmType.conditional) {
    // Nicely format the call to model_conditionalForest.

    extract = extract.replaceAllMapped(
      RegExp(
        r'\n (model_conditionalForest\(.*?)\)',
        multiLine: true,
        dotAll: false,
      ),
      (match) {
        String txt = match.group(1) ?? '';

        txt = txt.replaceAll('\n', '');
        txt = txt.replaceAll(RegExp(r',\s*m'), ', m');

        txt = txt.replaceAllMapped(
          RegExp(r'(\w+)\s*=\s*([^,]+),'),
          (match) {
            return '\n    ${match.group(1)}=${match.group(2)},';
          },
        );

        txt = txt.replaceAll(' = ', '=');

        return '\n$txt\n)\n';
      },
    );
  }

  return extract;
}

//   // Initialize with a value that indicates no start index found.

//   int startIndex = -1;

//   for (int i = lines.length - 1; i >= 0; i--) {
//     if (lines[i].contains(pat)) {
//       startIndex = i;
//       break;
//     }
//   }

//   if (startIndex != -1) {
//     for (int i = startIndex + 1; i < lines.length; i++) {
//       if (lines[i].startsWith(">")) {
//         // Found the next line starting with '>'. Stop adding lines to the
//         // result.

//         break;
//       }
//       result.add(lines[i]);
//     }
//   }

//   // Join the lines.

//   return result.join('\n');
// }
