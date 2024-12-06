/// A Button that repeats the onPressed action when held down.
//
// Time-stamp: <Wednesday 2024-10-09 06:01:35 +1100 Graham Williams>
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
/// Authors: Kevin Wang

library;

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';

import 'package:rattle/constants/spacing.dart';

class RepeatButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Duration initialDelay;
  final Duration repeatDelay;

  const RepeatButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.initialDelay = const Duration(milliseconds: 300),
    this.repeatDelay = const Duration(milliseconds: 100),
  }) : super(key: key);

  @override
  _RepeatButtonState createState() => _RepeatButtonState();
}

class _RepeatButtonState extends State<RepeatButton> {
  Timer? _timer;

  void _startRepeatingAction() {
    _timer = Timer(widget.initialDelay, () {
      widget.onPressed();
      _timer = Timer.periodic(widget.repeatDelay, (_) => widget.onPressed());
    });
  }

  void _stopRepeatingAction() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: _startRepeatingAction,
      onLongPressUp: _stopRepeatingAction,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        child: widget.child,
      ),
    );
  }
}

class RandomSeedRow extends StatelessWidget {
  final int randomSeed;
  final Function(int) updateSeed;

  const RandomSeedRow({
    Key? key,
    required this.randomSeed,
    required this.updateSeed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MarkdownTooltip(
          message: '''
          **Decrease Random Seed:**
          Tap to decrease the random seed value by 1.
          
          **Hold:** Hold the button to continuously decrease the value.
          ''',
          child: RepeatButton(
            child: const Icon(Icons.remove),
            onPressed: () {
              final newSeed = randomSeed - 1;
              if (newSeed >= 0) updateSeed(newSeed);
            },
          ),
        ),
        buttonGap,
        MarkdownTooltip(
          message: '''
          **Current Random Seed:**
          Displays the current random seed value being used.
          ''',
          child: Text(
            randomSeed.toString(),
            style: const TextStyle(fontSize: 18),
          ),
        ),
        buttonGap,
        MarkdownTooltip(
          message: '''
          **Increase Random Seed:**
          Tap to increase the random seed value by 1.
          
          **Hold:** Hold the button to continuously increase the value.
          ''',
          child: RepeatButton(
            child: const Icon(Icons.add),
            onPressed: () {
              final newSeed = randomSeed + 1;
              updateSeed(newSeed);
            },
          ),
        ),
        buttonGap,
        MarkdownTooltip(
          message: '''
          **Generate New Random Seed:**
          Tap this button to generate a completely new random seed value.
          ''',
          child: ElevatedButton(
            onPressed: () {
              final randomValue = Random().nextInt(100000);
              updateSeed(randomValue);
            },
            child: const Text('Random'),
          ),
        ),
      ],
    );
  }
}
