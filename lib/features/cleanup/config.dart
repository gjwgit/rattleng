/// Widget to configure the SVM tab: button.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Sunday 2024-08-04 07:47:17 +1000 Graham Williams>
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

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rattle/constants/spacing.dart';
import 'package:rattle/providers/delete_vars.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/utils/get_inputs.dart';

import 'package:rattle/utils/show_under_construction.dart';
import 'package:rattle/widgets/activity_button.dart';
import 'package:rattle/widgets/delayed_tooltip.dart';

/// The SVM tab config currently consists of just an ACTIVITY button.
///
/// This is a StatefulWidget to pass the ref across to the rSource.

class CleanupConfig extends ConsumerStatefulWidget {
  const CleanupConfig({super.key});

  @override
  ConsumerState<CleanupConfig> createState() => CleanupConfigState();
}

class CleanupConfigState extends ConsumerState<CleanupConfig> {
  // List choice of methods for cleanup.

  List<String> methods = [
    'Delete Ignored',
    'Delete Selected',
    'Delete Missing',
    'Delete Obs with Missing',
  ];

  String selectedCleanup = 'Delete Ignored';
  Widget cleanupChooser() {
    return Expanded(
      child: Wrap(
        spacing: 5.0,
        children: methods.map((cleanupMethod) {
          return ChoiceChip(
            label: Text(cleanupMethod),
            disabledColor: Colors.grey,
            selectedColor: Colors.lightBlue[200],
            backgroundColor: Colors.lightBlue[50],
            shadowColor: Colors.grey,
            pressElevation: 8.0,
            elevation: 2.0,
            selected: selectedCleanup == cleanupMethod,
            onSelected: (bool selected) {
              setState(() {
                selectedCleanup = selected ? cleanupMethod : '';
              });
            },
          );
        }).toList(),
      ),
    );
  }
    // BUILD button action.

  void buildAction() {
    // Run the R scripts.

    switch (selectedCleanup) {
      case 'Delete Ignored':
        debugPrint('deleted ignored vars: ${getIgnored(ref).toString()}');
        rSource(context, ref, 'transform_clean_delete_ignored');
      case 'Delete Selected':
        rSource(context, ref, 'transform_clean_delete_selected');
      case 'Delete Missing':
        rSource(context, ref, 'transform_clean_delete_vars_missing');
      case 'Delete Obs with Missing':
        rSource(context, ref, 'transform_clean_delete_obs_missing');
      default:
        showUnderConstruction(context);
    }
    // Notice that rSource is asynchronous so this glimpse is oftwn happening
    // before the above transformation.
    //
    // rSource(context, ref, 'glimpse');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Space above the beginning of the configs.

        const SizedBox(height: 5),

        Row(
          children: [
            // Space to the left of the configs.

            const SizedBox(width: 5),

            // The BUILD button.

            ActivityButton(
              onPressed: () {
                buildAction();
              },
              child: const Text('Cleanup the Dataset'),
            ),
            configWidgetSpace,
            cleanupChooser(),
            // Row(
            //   children: [
            //     Checkbox(
            //       value: ref.watch(deleteIgnored),
            //       onChanged: (bool? v) => {
            //         ref.read(deleteIgnored.notifier).state = v!,
            //       },
            //     ),
            //     const DelayedTooltip(
            //       message: '''

            //       Delete the variables marked as IGNORE role.

            //       ''',
            //       child: Text('Delete Ignored'),
            //     ),
            //   ],
            // ),
            // const SizedBox(width: 20),
            // Row(
            //   children: [
            //     Checkbox(
            //       value: ref.watch(deleteSelected),
            //       onChanged: (bool? v) => {
            //         ref.read(deleteSelected.notifier).state = v!,
            //       },
            //     ),
            //     const DelayedTooltip(
            //       message: '''

            //       Delete the variable selected.

            //       ''',
            //       child: Text('Delete Selected'),
            //     ),
            //   ],
            // ),
            // const SizedBox(width: 20),
            // Row(
            //   children: [
            //     Checkbox(
            //       value: ref.watch(deleteMissing),
            //       onChanged: (bool? v) => {
            //         ref.read(deleteMissing.notifier).state = v!,
            //       },
            //     ),
            //     const DelayedTooltip(
            //       message: '''

            //       Delete variables that have any missing values.

            //       ''',
            //       child: Text('Delete Missing'),
            //     ),
            //   ],
            // ),
            // const SizedBox(width: 20),
            // Row(
            //   children: [
            //     Checkbox(
            //       value: ref.watch(deleteObsWithMissing),
            //       onChanged: (bool? v) => {
            //         ref.read(deleteObsWithMissing.notifier).state = v!,
            //       },
            //     ),
            //     const DelayedTooltip(
            //       message: '''

            //       Delete rows that have any missing values.

            //       ''',
            //       child: Text('Delete Obs with Missing'),
            //     ),
            //   ],
            // ),
          ],
        ),
      ],
    );
  }
}
