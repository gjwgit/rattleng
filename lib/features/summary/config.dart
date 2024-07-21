/// Widget to configure the SUMMARY tab with a button to generate the summary.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Sunday 2024-07-21 16:26:07 +1000 Graham Williams>
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

import 'package:rattle/r/source.dart';
import 'package:rattle/widgets/activity_button.dart';

/// The SUMMARY tab config currently consists of just a BUILD button.
///
/// This is a StatefulWidget to pass the ref across to the rSource.

class SummaryConfig extends ConsumerStatefulWidget {
  const SummaryConfig({super.key});

  @override
  ConsumerState<SummaryConfig> createState() => SummaryConfigState();
}

class SummaryConfigState extends ConsumerState<SummaryConfig> {
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
                rSource(context, ref, 'explore_summary');
              },
              child: const Text('Generate Dataset Summary'),
            ),
            const SizedBox(width: 20.0),
            const Text(
              'A variety of R functions are utilised to summarise the dataset.',
            ),
          ],
        ),
      ],
    );
  }
}
