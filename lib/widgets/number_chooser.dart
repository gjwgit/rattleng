/// Widget to select the interval in rescale tab
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Sunday 2024-08-04 07:46:47 +1000 Graham Williams>
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

library;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rattle/providers/interval.dart';

class NumberChooser extends ConsumerStatefulWidget {
  const NumberChooser({super.key});

  @override
  NumberChooserState createState() => NumberChooserState();
}

class NumberChooserState extends ConsumerState<NumberChooser> {
  final TextEditingController _valCtrl = TextEditingController();
  Timer? timer;
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _valCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // update the provider and the interval in the gui
  void _updateInterval() {
    // try to parse the text, set to initial value if failed
    int? v = int.tryParse(_valCtrl.text);
    if (v == null) {
      ref.read(intervalProvider.notifier).state = initInterval;
    } else {
      ref.read(intervalProvider.notifier).state = v;
    }
    // Update the text field to reflect the new value
    // When the text is 100 and user types 100gsdfs, internally the provider didn't change. In the case, we had to manually change the text.
    _valCtrl.text = ref.read(intervalProvider.notifier).state.toString();
    debugPrint(
      'Interval updated to ${ref.read(intervalProvider.notifier).state}.',
    );
  }

  void _onFocusChange() {
    // triggered after losing focus
    if (!_focusNode.hasFocus) {
      _updateInterval();
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    _valCtrl.text = ref.read(intervalProvider.notifier).state.toString();
  }

  void startTimer(Function? ontap) {
    ontap?.call();
    timer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
      ontap?.call();
    });
  }

  void endTimer() => timer?.cancel();

  void _increment() {
    ref.read(intervalProvider.notifier).update((state) => state + 1);
  }

  void _decrement() {
    setState(() {
      if (ref.read(intervalProvider.notifier).state > 1) {
        ref.read(intervalProvider.notifier).update((state) => state - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int interval = ref.watch(intervalProvider);
    _valCtrl.text = interval.toString();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 100,
            child: TextFormField(
              controller: _valCtrl,
              focusNode: _focusNode,
              keyboardType: TextInputType.number,
              onEditingComplete: () {
                // triggered after user clicks enter
                _updateInterval();
              },
            ),
          ),
          Column(
            children: [
              GestureDetector(
                onLongPressStart: (details) => startTimer.call(_increment),
                onLongPressEnd: (details) => endTimer.call(),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.arrow_drop_up),
                  onPressed: _increment,
                ),
              ),
              GestureDetector(
                onLongPressStart: (details) => startTimer.call(_decrement),
                onLongPressEnd: (details) => endTimer.call(),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.arrow_drop_down),
                  onPressed: _decrement,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
