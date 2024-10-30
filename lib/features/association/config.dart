/// Widget to configure the ASSOCIATION tab: button.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Saturday 2024-10-05 13:34:28 +1000 Graham Williams>
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
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/spacing.dart';
import 'package:rattle/providers/association.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/utils/get_target.dart';
import 'package:rattle/widgets/activity_button.dart';
import 'package:rattle/widgets/number_field.dart';
import 'package:rattle/widgets/vector_number_field.dart';

/// The ASSOCIATION tab config currently consists of just an ACTIVITY button.
///
/// This is a StatefulWidget to pass the ref across to the rSource.

class AssociationConfig extends ConsumerStatefulWidget {
  const AssociationConfig({super.key});

  @override
  ConsumerState<AssociationConfig> createState() => AssociationConfigState();
}

class AssociationConfigState extends ConsumerState<AssociationConfig> {
  final TextEditingController _supportController = TextEditingController();
  final TextEditingController _confidenceController = TextEditingController();
  final TextEditingController _minLengthController = TextEditingController();

  @override
  void dispose() {
    // Dispose the controllers to free up resources.

    _supportController.dispose();
    _confidenceController.dispose();
    _minLengthController.dispose();

    super.dispose();
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
              onPressed: () async {
                await rSource(
                  context,
                  ref,
                  ['model_template', 'model_build_association'],
                );
              },
              child: const Text('Build Association Rules'),
            ),
            configWidgetSpace,
            Text('Target: ${getTarget(ref)}'),
            configWidgetSpace,
            NumberField(
              label: 'Support:',
              key: const Key('supportAssociationField'),
              controller: _supportController,
              tooltip: '''

                Support measures how frequently an item or itemset appears 
                in a dataset, indicating its ove.

                ''',
              inputFormatter: FilteringTextInputFormatter.allow(
                RegExp(r'^[0-9]*\.?[0-9]{0,4}$'),
              ),
              validator: (value) => validateDecimal(value),
              stateProvider: supportAssociationProvider,
              interval: 0.005,
              decimalPlaces: 4,
            ),
            configWidgetSpace,
            NumberField(
              label: 'Confidence:',
              key: const Key('confidenceAssociationField'),
              controller: _confidenceController,
              tooltip: '''

                Confidence measures the likelihood that an item appears in transactions 
                containing another item, indicating the strength of the rule.

                ''',
              inputFormatter: FilteringTextInputFormatter.allow(
                RegExp(r'^[0-9]*\.?[0-9]{0,4}$'),
              ),
              validator: (value) => validateDecimal(value),
              stateProvider: confidenceAssociationProvider,
              interval: 0.005,
              decimalPlaces: 4,
            ),
            configWidgetSpace,
            NumberField(
              label: 'Min Length:',
              key: const Key('minLengthAssociationField'),
              controller: _minLengthController,
              tooltip: '''

                Min length sets the minimum number of items in the itemsets or 
                rules generated, controlling the complexity of the rules.

                ''',
              inputFormatter:
                  FilteringTextInputFormatter.digitsOnly, // Integers only
              validator: validateVector,
              stateProvider: minLengthAssociationProvider,
            ),
          ],
        ),
      ],
    );
  }
}
