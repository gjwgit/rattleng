/// Widget to configure the CORRELATION tab: button.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Wednesday 2024-09-18 15:10:13 +1000 Graham Williams>
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

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rattle/providers/page_controller.dart';

import 'package:rattle/r/source.dart';
import 'package:rattle/widgets/activity_button.dart';

/// The CORRELATION tab config currently consists of just a BUILD button.
///
/// This is a StatefulWidget to pass the ref across to the rSource.

class CorrelationConfig extends ConsumerStatefulWidget {
  const CorrelationConfig({super.key});

  @override
  ConsumerState<CorrelationConfig> createState() => CorrelationConfigState();
}

class CorrelationConfigState extends ConsumerState<CorrelationConfig> {
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
              onPressed: () {
                rSource(context, ref, 'explore_correlation');
                // wait for 3 seconds before moving to the next page.
                Future.delayed(const Duration(seconds: 3));
                ref.read(correlationPageControllerProvider).animateToPage(
                      // Index of the second page.
                      1,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
              },
              child: const Text('Perform Correlation Analysis'),
            ),
          ],
        ),
      ],
    );
  }
}
