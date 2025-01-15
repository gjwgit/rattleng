/// Choose a dataset from a package
///
/// Time-stamp: <Wednesday 2023-11-01 08:41:55 +1100 Graham Williams>
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
/// Authors: Yixiang Yin
/// 

library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rattle/providers/dataset.dart';
import 'package:rattle/providers/path.dart';
  // Function to show package options
  Future<String> datasetSelectPackage(
    BuildContext context,
    Map<String, List<String>> packageMap,
    WidgetRef ref,
  ) async {
    String path = '';
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Available Packages'),
          content: SizedBox(
            width:
                double.maxFinite, 
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: packageMap.entries.expand((entry) {
                  // Expand each package into a list of ListTile widgets
                  return entry.value.map((dataset) {
                    return ListTile(
                      title: Text(
                        '${entry.key} - $dataset',
                      ), 
                      onTap: () {
                        ref.read(pathProvider.notifier).state =
                            '${entry.key}::$dataset';
                        debugPrint(
                          'update path provider to ${ref.read(pathProvider)}',
                        );

                        ref.read(datasetProvider.notifier).state = '$dataset';
                        ref.read(packageProvider.notifier).state =
                            '${entry.key}';

                        path = ref.read(pathProvider);

                        Navigator.of(context).pop();
                        // Navigator.of(context).pop();
                        debugPrint(
                          'Selected Package: ${entry.key}, Dataset: $dataset',
                        );
                      },
                    );
                  }).toList();
                }).toList(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
    return path;
  }
