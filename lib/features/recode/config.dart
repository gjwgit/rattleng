/// Widget to configure the RECODE feature of the TRANSFORM tab.
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Monday 2024-08-19 08:27:02 +1000 Graham Williams>
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
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/spacing.dart';
import 'package:rattle/providers/number.dart';
import 'package:rattle/providers/selected.dart';
// TODO 20240819 gjw RENAME SELECTED2 TO SECONDARY
import 'package:rattle/providers/selected2.dart';
import 'package:rattle/providers/vars/types.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/utils/get_inputs.dart';
import 'package:rattle/utils/show_under_construction.dart';
import 'package:rattle/widgets/activity_button.dart';
import 'package:rattle/widgets/choice_chip_tip.dart';
import 'package:rattle/widgets/number_field.dart';

// TODO 20240819 gjw REQUIRES A COMPREHENSIVE CLEANUP/STRUCTURE

/// A StatefulWidget to pass the ref across to the rSource as well as to monitor
/// the selected variable.

class RecodeConfig extends ConsumerStatefulWidget {
  const RecodeConfig({super.key});

  @override
  ConsumerState<RecodeConfig> createState() => RecodeConfigState();
}

class RecodeConfigState extends ConsumerState<RecodeConfig> {
  // TODO 20240819 gjw EACH WIDGET NEEDS A COMMENT

  Widget variableChooser(
    String label,
    List<String> inputs,
    String selected,
    WidgetRef ref,
    StateProvider stateProvider,
  ) {
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
        // reset after selection
        selectedTransform = ref.read(typesProvider)[value] == Type.numeric
            ? numericMethods.first
            : categoricMethods.first;
      },
    );
  }

  // the reason we use this instead of the provider is that the provider will only be updated after build.
  // Before build, selected contains the most recent value.
  String selected = 'NULL';
  String selectedTransform = '';

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
  }

  Widget recodeChooser(inputs, selected2) {
    final TextEditingController valCtrl = TextEditingController();
    valCtrl.text = ref.read(numberProvider.notifier).state.toString();

    bool isNumeric = true;

    // On startup with no dataset (so nothing selected) the default is to enable
    // all the chips.

    if (selected != 'NULL') {
      isNumeric = ref.read(typesProvider)[selected] == Type.numeric;
    }

    // TODO 20240819 gjw WHERE ARE THE TOOLTIPS?

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
        ChoiceChipTip(
          enabled: selected == 'NULL' || !isNumeric,
          options: categoricMethods,
          selectedOption: !isNumeric ? selectedTransform : '',
          onSelected: (String? selected) {
            setState(() {
              selectedTransform = selected ?? '';
            });
          },
        ),
        configWidgetSpace,
        Expanded(
          child: variableChooser(
            'Secondary',
            inputs,
            selected2,
            ref,
            selected2Provider,
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
        // initialise the chip selection
        selectedTransform = ref.read(typesProvider)[selected] == Type.numeric
            ? numericMethods.first
            : categoricMethods.first;
        debugPrint('selected changed to $selected');
      });
    }
    // This is to ensure if we come back later, the selection is not cleared
    if (selected != 'NULL' && selectedTransform == '') {
      selectedTransform = ref.read(typesProvider)[selected] == Type.numeric
          ? numericMethods.first
          : categoricMethods.first;
    }

    String selected2 = ref.watch(selected2Provider);
    if (selected2 == 'NULL' && inputs.isNotEmpty) {
      selected2 = inputs[1];
    }

    return Column(
      children: [
        configTopSpace,
        Row(
          children: [
            configTopSpace,
            ActivityButton(
              onPressed: () {
                ref.read(selectedProvider.notifier).state = selected;
                ref.read(selected2Provider.notifier).state = selected2;
                buildAction();
              },
              child: const Text('Recode Variable Values'),
            ),
            configWidgetSpace,
            variableChooser(
              'Variable',
              inputs,
              selected,
              ref,
              selectedProvider,
            ),
          ],
        ),
        configTopSpace,
        recodeChooser(inputs, selected2),
      ],
    );
  }
}
