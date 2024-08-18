import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Widget variableChooser(String label, List<String> inputs, String selected,
    WidgetRef ref, StateProvider stateProvider, ) {
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
      // We don't buildAction() here since the variable choice might
      // be followed by a transform choice and we don;t want to shoot
      // off building lots of new variables unnecesarily.
    },
  );
}
