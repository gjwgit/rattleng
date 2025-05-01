/// A numerical text input field.
//
// Time-stamp: <Friday 2024-12-13 08:49:23 +1100 Graham Williams>
//
/// Copyright (C) 2024, Togaware Pty Ltd
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
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
/// Authors: Zheyuan Xu

library;

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rattle/constants/style.dart';

class NumberField extends ConsumerStatefulWidget {
  final String label;
  final TextEditingController controller;
  final StateProvider stateProvider;
  final String tooltip;
  final bool enabled;
  final String? Function(String?) validator;
  final TextInputFormatter inputFormatter;
  final int maxWidth;
  final num interval;
  final int decimalPlaces;
  final num? min;
  final num? max;
  final Future<void> Function(String? newValue)? onValueChanged;
  final String? sharedPrefsKey;
  final VoidCallback? onUpDownPressed;
  final int tapDelay;

  const NumberField({
    super.key,
    required this.controller,
    required this.stateProvider,
    required this.validator,
    required this.inputFormatter,
    this.min,
    this.max,
    this.label = '',
    this.tooltip = '',
    this.enabled = true,
    this.maxWidth = 5,
    this.decimalPlaces = 0,
    this.interval = 1, // Default interval is 1, can be set as double or int
    this.onValueChanged,
    this.sharedPrefsKey,
    this.onUpDownPressed,
    this.tapDelay = 1000,
  });

  @override
  NumberFieldState createState() => NumberFieldState();
}

class NumberFieldState extends ConsumerState<NumberField> {
  final FocusNode _focusNode = FocusNode();

  // Flag to prevent update loops between the TextEditingController and StateProvider.

  bool _isInternalChange = false;

  // Timer for debouncing the onUpDownPressed callback.

  Timer? _debounceTimer;

  @override
  void dispose() {
    _focusNode.dispose();
    _debounceTimer?.cancel(); // Cancel any pending debounce timers
    super.dispose();
  }

  // Call the onUpDownPressed callback with debouncing if needed.

  void _triggerUpDownCallback() {
    // If no callback is provided, do nothing.

    if (widget.onUpDownPressed == null) return;

    // Cancel any existing timer to reset the delay.

    _debounceTimer?.cancel();

    // If a delay is specified, use debouncing.

    _debounceTimer = Timer(Duration(milliseconds: widget.tapDelay), () {
      widget.onUpDownPressed?.call();
    });
  }

  // Stores the current cursor position to maintain it during updates.

  TextSelection? _previousSelection;

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      updateField();
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);

    // Load initial value from SharedPreferences if key is provided.

    if (widget.sharedPrefsKey != null) {
      _loadFromSharedPrefs();
    }

    // Listen to provider changes and update the controller.

    ref.listenManual(
      widget.stateProvider,
      (previous, next) {
        if (!_isInternalChange) {
          setState(() {
            // Store the current selection before updating text.

            _previousSelection = widget.controller.selection;

            widget.controller.text = next.toString();

            // Restore the cursor position after text update.

            if (_previousSelection != null && _focusNode.hasFocus) {
              widget.controller.selection = TextSelection.collapsed(
                offset: min(
                  _previousSelection!.baseOffset,
                  widget.controller.text.length,
                ),
              );
            }
          });
        }
      },
      fireImmediately: true,
    );
  }

  Future<void> _loadFromSharedPrefs() async {
    if (widget.sharedPrefsKey == null) return;

    final prefs = await SharedPreferences.getInstance();

    if (widget.decimalPlaces > 0) {
      final savedValue = prefs.getDouble(widget.sharedPrefsKey!);
      if (savedValue != null) {
        _isInternalChange = true;
        ref.read(widget.stateProvider.notifier).state = savedValue;
        _isInternalChange = false;
      }
    } else {
      final savedValue = prefs.getInt(widget.sharedPrefsKey!);
      if (savedValue != null) {
        _isInternalChange = true;
        ref.read(widget.stateProvider.notifier).state = savedValue;
        _isInternalChange = false;
      }
    }
  }

  Future<void> _saveToSharedPrefs(num value) async {
    if (widget.sharedPrefsKey == null) return;

    final prefs = await SharedPreferences.getInstance();

    if (widget.decimalPlaces > 0) {
      await prefs.setDouble(widget.sharedPrefsKey!, value.toDouble());
    } else {
      await prefs.setInt(widget.sharedPrefsKey!, value.toInt());
    }
  }

  void increment() async {
    num currentValue = num.tryParse(widget.controller.text) ?? 0;
    currentValue += widget.interval;

    // Automatically cap at the max if specified.

    if (widget.max != null) {
      currentValue = min(currentValue, widget.max!);
    }

    // Round to the specified decimal places if needed.

    if (widget.decimalPlaces > 0) {
      currentValue =
          double.parse(currentValue.toStringAsFixed(widget.decimalPlaces));
    }

    ref.read(widget.stateProvider.notifier).state = currentValue;

    // Save to SharedPreferences if key is provided.

    if (widget.sharedPrefsKey != null) {
      await _saveToSharedPrefs(currentValue);
    }

    if (widget.label == 'Seed:') {
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('randomSeed', currentValue.toInt());
    }

    // Trigger the callback with debouncing.

    _triggerUpDownCallback();
  }

  void decrement() async {
    num currentValue = num.tryParse(widget.controller.text) ?? 0;
    currentValue -= widget.interval;

    // Automatically floor at min if specified.

    if (widget.min != null) {
      currentValue = max(currentValue, widget.min!);
    }

    // Round to the specified decimal places if needed.

    if (widget.decimalPlaces > 0) {
      currentValue =
          double.parse(currentValue.toStringAsFixed(widget.decimalPlaces));
    }

    ref.read(widget.stateProvider.notifier).state = currentValue;

    // Save to SharedPreferences if key is provided.

    if (widget.sharedPrefsKey != null) {
      await _saveToSharedPrefs(currentValue);
    }

    // Legacy code for backward compatibility.

    if (widget.label == 'Seed:') {
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('randomSeed', currentValue.toInt());
    }

    // Trigger the callback with debouncing.

    _triggerUpDownCallback();
  }

  // A timer for continuous incrementing/decrementing.

  Timer? timer;

  void startIncrementing() {
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      increment();
    });
  }

  void stopIncrementing() {
    timer?.cancel();
  }

  void startDecrementing() {
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      decrement();
    });
  }

  void stopDecrementing() {
    timer?.cancel();
  }

  void updateField() async {
    // Store current cursor position.

    _previousSelection = widget.controller.selection;

    String updatedText = widget.controller.text;
    num? v = num.tryParse(updatedText);

    if (v == null) {
      // If the parsing fails, set to 0 or min.

      v = widget.min ?? 0;
    } else {
      // Apply min and max constraints.

      if (widget.min != null) {
        v = max(v, widget.min!);
      }
      if (widget.max != null) {
        v = min(v, widget.max!);
      }
    }

    // Controller text automatically updates to
    // the range of [widget.min] and [widget.max].

    widget.controller.text = v.toString();

    // Apply decimal places if needed.

    if (widget.decimalPlaces > 0) {
      v = double.parse(v.toStringAsFixed(widget.decimalPlaces));
    }

    _isInternalChange = true;

    // Update the state.

    ref.read(widget.stateProvider.notifier).state = v;

    // Save to SharedPreferences if key is provided.

    if (widget.sharedPrefsKey != null) {
      await _saveToSharedPrefs(v);
    }

    // Call onValueChanged callback if provided.

    if (widget.onValueChanged != null) {
      await widget.onValueChanged!(v.toString());
    }

    // Restore cursor position if needed.

    if (_previousSelection != null && _focusNode.hasFocus) {
      widget.controller.selection = TextSelection.collapsed(
        offset:
            min(_previousSelection!.baseOffset, widget.controller.text.length),
      );
    }

    // Trigger the callback after all updates are done.

    _triggerUpDownCallback();

    _isInternalChange = false;
  }

  @override
  Widget build(BuildContext context) {
    // Watch the state provider to ensure the widget rebuilds when the value changes.

    ref.watch(widget.stateProvider);

    return MarkdownTooltip(
      message: widget.tooltip,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: widget.maxWidth * 30.0,
            child: Stack(
              children: [
                TextFormField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    labelText: widget.label,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                    border: const UnderlineInputBorder(),
                    contentPadding: const EdgeInsets.only(
                      right: 40,
                      left: 0,
                    ),
                    errorText: widget.validator(widget.controller.text),
                    errorStyle: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onEditingComplete: () {
                    // Store selection before completing edit.

                    _previousSelection = widget.controller.selection;
                    updateField();
                  },
                  onChanged: (value) {
                    // Store the current selection.

                    _previousSelection = widget.controller.selection;

                    // Only perform basic validation, don't update field yet.

                    if (value.isNotEmpty &&
                        !RegExp(r'^[0-9.]+$').hasMatch(value)) {
                      String newValue =
                          value.replaceAll(RegExp(r'[^0-9.]'), '');
                      widget.controller.value = TextEditingValue(
                        text: newValue,
                        selection: TextSelection.collapsed(
                          offset: min(
                            _previousSelection!.baseOffset,
                            newValue.length,
                          ),
                        ),
                      );
                    }

                    updateField();
                  },
                  style: widget.enabled ? normalTextStyle : disabledTextStyle,
                  enabled: widget.enabled,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    widget.inputFormatter,
                  ],
                ),
                // Positioned Arrow Buttons.

                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: widget.enabled ? increment : null,
                        onLongPressStart: widget.enabled
                            ? (details) => startIncrementing()
                            : null,
                        onLongPressEnd: widget.enabled
                            ? (details) => stopIncrementing()
                            : null,
                        child: const Icon(Icons.arrow_drop_up),
                      ),
                      GestureDetector(
                        onTap: widget.enabled ? decrement : null,
                        onLongPressStart: widget.enabled
                            ? (details) => startDecrementing()
                            : null,
                        onLongPressEnd: widget.enabled
                            ? (details) => stopDecrementing()
                            : null,
                        child: const Icon(Icons.arrow_drop_down),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Validation logic for integer fields.

String? validateInteger(
  String? value, {
  required int min,
  int? max,
}) {
  if (value == null || value.isEmpty) return 'Cannot be empty';

  int? intValue = int.tryParse(value);
  if (intValue == null) {
    return 'Must be a valid number';
  }

  if (intValue < min) {
    return 'Must be at least $min';
  }

  if (max != null && intValue > max) {
    return 'Must be at most $max';
  }

  return null;
}

// Validation logic for decimal field.

String? validateDecimal(String? value) {
  if (value == null || value.isEmpty) return 'Cannot be empty';
  double? doubleValue = double.tryParse(value);
  if (doubleValue == null || doubleValue < 0.0000 || doubleValue > 1.0000) {
    return 'Must be between 0.0000 and 1.0000';
  }

  return null;
}
