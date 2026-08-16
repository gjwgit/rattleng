/// A traffic light in the app bar showing what the R process is doing.
///
/// Time-stamp: "Sunday 2026-08-16 09:20:00 +1000 Graham Williams"
///
/// Copyright (C) 2026, Togaware Pty Ltd.
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://opensource.org/license/gpl-3-0
///
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

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';

import 'package:rattle/providers/r_status.dart';

/// Show whether R is idle, busy, or has stopped.
///
/// Rattle hands our R code to an R session running alongside the app, and until
/// R has finished with it the panels have nothing new to show. Without some
/// indication of that, a slow model build is indistinguishable from an app that
/// has stopped responding. The light reports what R is actually doing.

class RStatusLight extends ConsumerWidget {
  const RStatusLight({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final RStatus status = ref.watch(rStatusProvider);

    final (Color colour, String label, String advice) = switch (status) {
      RStatus.ready => (
          Colors.green,
          'Ready',
          'R has finished and is waiting for you. Any output is on the panel '
              'behind, with the detail in the **Console** tab.',
        ),
      RStatus.running => (
          Colors.amber,
          'Running',
          'R is running your code. A model over a large dataset can take a '
              'while, so the panels will not update until this turns green. '
              'Watch the **Console** tab to see how it is going.',
        ),
      RStatus.failed => (
          Colors.red,
          'Stopped',
          'R reported an error, or the R session has stopped. Whatever you '
              'last asked for may be missing or incomplete. See the '
              '**Console** tab for what R reported. The light turns green '
              'again once the next request succeeds.',
        ),
    };

    return MarkdownTooltip(
      message: '''

      **R is $label**

      $advice

      ''',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // A ring around the light so that it reads as a light rather than
            // as a coloured dot, and so it stays visible on any app bar colour.

            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: colour,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black26),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
