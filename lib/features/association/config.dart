/// Widget to configure the ASSOCIATION tab: button.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Saturday 2024-12-14 21:00:49 +1100 Graham Williams>
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
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/utils/get_target.dart';
import 'package:rattle/utils/variable_chooser.dart';
import 'package:rattle/widgets/activity_button.dart';
import 'package:rattle/widgets/labelled_checkbox.dart';
import 'package:rattle/widgets/number_field.dart';
import 'package:rattle/widgets/vector_number_field.dart';

/// Sort by methods of ASSOCIATION rules.

List<String> associationRulesSortBy = [
  'Support',
  'Confidence',
  'Lift',
];

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
  final TextEditingController _limitNumberMeasureController =
      TextEditingController();

  @override
  void dispose() {
    // Dispose the controllers to free up resources.

    _supportController.dispose();
    _confidenceController.dispose();
    _minLengthController.dispose();
    _limitNumberMeasureController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String sortByAssociation =
        ref.read(sortByAssociationProvider.notifier).state;
    bool basketsTicked = ref.read(basketsAssociationProvider.notifier).state;

    return Column(
      spacing: configRowSpace,
      children: [
        configTopGap,
        Row(
          spacing: configWidgetSpace,
          children: [
            // Space to the left of the configs.

            const SizedBox(width: 5),

            // The BUILD button.

            ActivityButton(
              onPressed: () async {
                if (context.mounted)
                  await rSource(
                    context,
                    ref,
                    ['model_template', 'model_build_association'],
                  );
                await ref.read(associationControllerProvider).animateToPage(
                      // Index of the second page.
                      1,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
              },
              child: const Text('Build Association Rules'),
            ),

            Text('Target: ${getTarget(ref)}'),

            LabelledCheckbox(
              key: const Key('basketsAssociationField'),
              tooltip: '''

              If checked, baskets are identified by the ident variable and items
              in the basket by the target variable. Otherwise a basket is the
              collection of input variables.

              ''',
              label: 'Baskets',
              provider: basketsAssociationProvider,
              onSelected: (ticked) {
                setState(() {
                  if (ticked != null) {
                    ref.read(basketsAssociationProvider.notifier).state =
                        ticked;
                  }
                });
              },
            ),
          ],
        ),
        Row(
          spacing: configWidgetSpace,
          children: [
            configLeftGap,
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
            NumberField(
              label: 'Limit Rules:',
              key: const Key('measuresLimitAssociationField'),
              controller: _limitNumberMeasureController,
              tooltip: '''

                Limit the number of rules for display and calculating the
                measures of interest.

                ''',
              inputFormatter:
                  FilteringTextInputFormatter.digitsOnly, // Integers only
              validator: (value) => validateInteger(
                value,
                min: 2,
              ),
              stateProvider: interestMeasuresAssociationProvider,
              enabled: !basketsTicked,
            ),
            variableChooser(
              'Sort by:',
              associationRulesSortBy,
              sortByAssociation,
              ref,
              sortByAssociationProvider,
              tooltip: '''

              Refer to ranking rules based on metrics such as support, confidence,
              or lift to prioritize the most significant and relevant patterns.

              ''',
              onChanged: (String? value) {
                if (value != null) {
                  ref.read(sortByAssociationProvider.notifier).state = value;
                }
              },
              enabled: !basketsTicked,
            ),
          ],
        ),
      ],
    );
  }
}
