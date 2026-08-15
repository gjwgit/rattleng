/// A popup to predict the outcome for an observation entered by the user.
///
/// Time-stamp: "Saturday 2026-08-15 10:12:00 +1000 Graham Williams"
///
/// Copyright (C) 2026, Togaware Pty Ltd.
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://opensource.org/license/gpl-3-0
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
// this program.  If not, see <https://opensource.org/license/gpl-3-0>.
///
/// Authors: Graham Williams

library;

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';

import 'package:rattle/constants/spacing.dart';
import 'package:rattle/features/evaluate/interactive_field.dart';
import 'package:rattle/features/evaluate/interactive_models.dart';
import 'package:rattle/features/evaluate/interactive_variable.dart';
import 'package:rattle/providers/evaluate.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/providers/vars/roles.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/utils/wait_for_r_output.dart';

/// Enter a value for each model input variable and predict the outcome.
///
/// The variables, their datatypes and the levels of the categoric ones come
/// from R, so the fields always match the dataset as it currently stands, after
/// any transformations. Each ticked model then predicts the one observation, so
/// that the models can be compared on it.

class InteractivePopup extends ConsumerStatefulWidget {
  const InteractivePopup({super.key});

  @override
  ConsumerState<InteractivePopup> createState() => _InteractivePopupState();
}

class _InteractivePopupState extends ConsumerState<InteractivePopup> {
  List<InteractiveVariable> _variables = [];

  // The value of each variable. Text fields are driven by a controller so that
  // typing does not rebuild them, while the dropdowns are held here directly.

  final Map<String, TextEditingController> _controllers = {};
  final Map<String, String> _values = {};

  List<Map<String, dynamic>> _predictions = [];

  bool _loading = true;
  bool _predicting = false;
  String _message = '';

  @override
  void initState() {
    super.initState();

    // 20260815 gjw Wait for the first frame. Loading the variables sets the
    // TEMPLATE providers for the R script, and riverpod does not allow a
    // provider to be modified during a widget life-cycle such as initState:
    // "Tried to modify a provider while the widget tree was building".

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadVariables();
    });
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  /// The input variables, being those the user gave the Input role.

  List<String> get _inputs {
    final Map<String, Role> roles = ref.read(rolesProvider);

    return roles.entries
        .where((entry) => entry.value == Role.input)
        .map((entry) => entry.key)
        .toList();
  }

  /// Ask R to describe the input variables and build a field for each.

  Future<void> _loadVariables() async {
    final List<String> inputs = _inputs;

    if (inputs.isEmpty) {
      setState(() {
        _loading = false;
        _message = 'There are no **Input** variables. Visit the **Dataset** '
            'tab to give at least one variable the Input role.';
      });

      return;
    }

    ref.read(interactiveInputsProvider.notifier).state =
        'c(${inputs.map((name) => '"$name"').join(', ')})';

    final int from = ref.read(stdoutProvider).length;

    await rSource(context, ref, ['evaluate_interactive_variables']);

    final String json = await waitForROutput(
      ref,
      '> rat(interactive_vars_json, "\\n")',
      from: from,
    );

    final List<InteractiveVariable> variables =
        InteractiveVariable.fromJson(json);

    if (!mounted) return;

    setState(() {
      _loading = false;
      _variables = variables;

      for (final variable in variables) {
        _values[variable.name] = variable.initialValue;

        if (!variable.isCategoric) {
          _controllers[variable.name] =
              TextEditingController(text: variable.initialValue);
        }
      }

      if (variables.isEmpty) {
        _message = 'Unable to identify the input variables. See the '
            '**Console** tab for what R reported.';
      }
    });
  }

  /// Predict the entered observation with each of the ticked models.

  Future<void> _predict() async {
    final List<String> scripts = interactiveModelScripts(ref);

    if (scripts.isEmpty) {
      setState(() {
        _predictions = [];
        _message = 'No model is selected. Tick a **Model** at the top of the '
            'Evaluate tab, having built it in the **Model** tab.';
      });

      return;
    }

    setState(() {
      _predicting = true;
      _message = '';
      _predictions = [];
    });

    // The observation is the same for every model, so build it just the once.

    final String observation = _variables
        .map((variable) => variable.rArgument(_values[variable.name] ?? ''))
        .join(', ');

    ref.read(interactiveNewdataProvider.notifier).state =
        'data.frame($observation, stringsAsFactors=FALSE, check.names=FALSE)';

    final List<Map<String, dynamic>> predictions = [];

    for (final String script in scripts) {
      final int from = ref.read(stdoutProvider).length;

      if (!mounted) return;

      await rSource(context, ref, [script, 'evaluate_interactive_predict']);

      final String json = await waitForROutput(
        ref,
        '> rat(interactive_json, "\\n")',
        from: from,
      );

      try {
        final dynamic decoded = jsonDecode(json);
        if (decoded is Map<String, dynamic>) predictions.add(decoded);
      } on FormatException {
        // R could not predict with this model, which the CONSOLE explains, so
        // carry on with the models that can rather than lose them all.

        predictions.add({'model': script, 'prediction': 'Failed'});
      }
    }

    if (!mounted) return;

    setState(() {
      _predicting = false;
      _predictions = predictions;

      if (predictions.isEmpty) {
        _message = 'No prediction was returned. See the **Console** tab for '
            'what R reported.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.auto_graph, size: 24, color: Colors.blue),
          popupIconGap,
          Text('Interactive Prediction'),
        ],
      ),
      content: SizedBox(
        width: 600,
        child: _loading
            ? const SizedBox(
                height: 120,
                child: Center(child: CircularProgressIndicator()),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Enter a value for each input variable and then tap '
                    'Predict.',
                  ),
                  configRowGap,
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        children: _variables
                            .map(
                              (variable) => InteractiveField(
                                variable: variable,
                                value: _values[variable.name] ?? '',
                                controller: _controllers[variable.name],
                                onChanged: (entered) =>
                                    _values[variable.name] = entered,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                  if (_message.isNotEmpty) ...[
                    configRowGap,
                    Text(
                      _message.replaceAll('**', ''),
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ],
                  if (_predictions.isNotEmpty) ...[
                    configRowGap,
                    const Divider(),
                    ..._predictions.map(_predictionRow),
                  ],
                ],
              ),
      ),
      actions: [
        MarkdownTooltip(
          message: '''

          **Predict**

          Tap here to predict the outcome for the observation you have entered,
          using each of the models ticked at the top of the **Evaluate** tab. A
          prediction is shown for each model so you can compare them on the one
          observation.

          ''',
          child: ElevatedButton(
            onPressed: (_loading || _predicting) ? null : _predict,
            child: const Text('Predict'),
          ),
        ),
        MarkdownTooltip(
          message: '''

          **Close**

          Tap here to close the interactive prediction window.

          ''',
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ),
      ],
    );
  }

  /// The prediction from one model, with its probability where there is one.

  Widget _predictionRow(Map<String, dynamic> prediction) {
    final dynamic probability = prediction['probability'];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 260,
            child: Text(
              '${prediction['model']}',
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              '${prediction['prediction']}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          if (probability != null)
            Text('probability ${_asProbability(probability)}'),
        ],
      ),
    );
  }

  String _asProbability(dynamic probability) {
    final double? value = double.tryParse(probability.toString());

    return value == null ? '' : value.toStringAsFixed(4);
  }
}
