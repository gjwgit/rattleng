/// Widget to configure the SVM tab: button.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Sunday 2024-08-04 07:46:33 +1000 Graham Williams>
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
import 'package:provider/provider.dart';
import 'package:rattle/constants/spacing.dart';
import 'package:rattle/providers/number.dart';
import 'package:rattle/providers/selected.dart';
import 'package:rattle/providers/selected2.dart';
import 'package:rattle/providers/vars/types.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/utils/get_inputs.dart';

import 'package:rattle/utils/show_under_construction.dart';
import 'package:rattle/utils/update_roles_provider.dart';
import 'package:rattle/widgets/activity_button.dart';
import 'package:rattle/widgets/choice_chip_tip.dart';
import 'package:rattle/widgets/number_field.dart';

/// The SVM tab config currently consists of just an ACTIVITY button.
///
/// This is a StatefulWidget to pass the ref across to the rSource.

class RecodeConfig extends ConsumerStatefulWidget {
  const RecodeConfig({super.key});

  @override
  ConsumerState<RecodeConfig> createState() => RecodeConfigState();
}

class RecodeConfigState extends ConsumerState<RecodeConfig> {
  Widget variableChooser(String label, List<String> inputs, String selected,
      WidgetRef ref, StateProvider stateProvider,) {
    return DropdownMenu(
      // label: const Text('Variable'),
      label: Text(label),
      width: 200,
      initialSelection: selected,
      dropdownMenuEntries: inputs.map((s) {
        return DropdownMenuEntry(value: s, label: s);
      }).toList(),
      // On selection as well as recording what was selected rebuild the
      // visualisations.
      onSelected: (String? value) {
        // ref.read(selectedProvider.notifier).state = value ?? 'IMPOSSIBLE';
        ref.read(stateProvider.notifier).state = value ?? 'IMPOSSIBLE';
        selectedTransform = ref.read(typesProvider)[value] == Type.numeric ? numericMethods.first : categoricMethods.first;
        // We don't buildAction() here since the variable choice might
        // be followed by a transform choice and we don;t want to shoot
        // off building lots of new variables unnecesarily.
      },
    );
  }

  // the reason we use this instead of the provider is that the provider will only be updated after build.
  // Before build, selected contains the most recent value.
  String selected = 'NULL';
  String selectedTransform = 'Quantiles';

  List<String> numericMethods = [
    'Quantiles',
    'KMeans',
    'Equal Width',
  ];

  List<String> categoricMethods = [
    'Indicator Variable',
    'Join Categorics',
    // 'As Categoric',
    // 'As Numeric',
  ];

  // BUILD button action.

  void buildAction() {
    // Run the R scripts.

    switch (selectedTransform) {
      case 'Quantiles':
        rSource(context, ref, 'transform_recode_quantile');
      case 'KMeans':
        rSource(context, ref, 'transform_recode_kmeans');
      case 'Equal Width':
        rSource(context, ref, 'transform_recode_equal_width');
      case 'Indicator Variable':
        rSource(context, ref, 'transform_recode_indicator_variable');
      case 'Join Categorics':
        rSource(context, ref, 'transform_recode_join_categoric');
      // case 'As Categoric':
      //   rSource(context, ref, 'transform_rescale_log10_numeric');
      // case 'As Numeric':
      //   rSource(context, ref, 'transform_rescale_rank');
      default:
        showUnderConstruction(context);
    }
    // Notice that rSource is asynchronous so this glimpse is oftwn happening
    // before the above transformation.
    //
    // rSource(context, ref, 'glimpse');
  }

  Widget recodeChooser() {
    final TextEditingController valCtrl = TextEditingController();
    valCtrl.text = ref.read(numberProvider.notifier).state.toString();
    bool isNumeric;
    if (selected != 'NULL') {
      isNumeric = ref.read(typesProvider)[selected] == Type.numeric;
    } else {
      isNumeric = false;
      debugPrint('Error: selected is NULL!!!');
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ChoiceChipTip(
          options: numericMethods,
          selectedOption: selectedTransform,
          enabled: isNumeric,
          onSelected: (String? selected) {
            setState(() {
              selectedTransform = selected ?? '';
            });
          },
        ),
        configWidgetSpace,
        NumberField(
          label: 'Number',
          controller: valCtrl,
          stateProvider: numberProvider,
          validator: (value) => validateInteger(value, min: 1),
          inputFormatter: FilteringTextInputFormatter.digitsOnly,
          enabled: isNumeric,
        ),
        configWidgetSpace,
        Expanded(
          child: ChoiceChipTip(
            enabled: !isNumeric,
            options: categoricMethods,
            selectedOption: !isNumeric ? selectedTransform : '',
            onSelected: (String? selected) {
              setState(() {
                selectedTransform = selected ?? '';
              });
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // updateVariablesProvider(ref);
    List<String> inputs = getInputsAndIgnoreTransformed(ref);
    selected = ref.watch(selectedProvider);
    if (selected == 'NULL' && inputs.isNotEmpty) {
      setState(() {
        selected = inputs.first;
        debugPrint('selected changed to $selected');
      });
    }
    String selected2 = ref.watch(selected2Provider);
    if (selected2 == 'NULL' && inputs.isNotEmpty) {
      selected2 = inputs[1];
    }

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
                // showUnderConstruction(context);
                ref.read(selectedProvider.notifier).state = selected;
                ref.read(selected2Provider.notifier).state = selected2;
                buildAction();
              },
              child: const Text("Recode Variable's Values"),
            ),
            configWidgetSpace,
            variableChooser(
                'Variable', inputs, selected, ref, selectedProvider),
            configWidgetSpace,
            variableChooser(
                'Second Variable', inputs, selected2, ref, selected2Provider),
          ],
        ),
        recodeChooser(),
      ],
    );
  }
}
