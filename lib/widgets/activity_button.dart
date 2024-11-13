/// An ElevatedButton implementing Activity initiation for Rattle.
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
/// Authors: Graham Williams, Yixiang Yin, Kevin Wang

library;

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/providers/path.dart';
import 'package:rattle/utils/debug_text.dart';
import 'package:rattle/utils/show_ok.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';

class ActivityButton extends ConsumerWidget {
  final StateProvider<PageController>? pageControllerProvider;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Widget child;

  const ActivityButton({
    super.key,
    // Optional for navigation.
    this.pageControllerProvider,
    // Optional for additional logic
    this.onPressed,
    this.tooltip,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugText('  BUILD', 'ActivityButton');

    return MarkdownTooltip(
      message: tooltip ??
          '''

      Tap here to build the Pages for this Feature.

      ''',
      child: ElevatedButton(
        onPressed: () {
          String path = ref.read(pathProvider);

          if (path.isEmpty) {
            showOk(
              context: context,
              title: 'No Dataset Loaded',
              content: '''

            Please choose a dataset to load from the **Dataset** tab. There is
            not much we can do until we have loaded a dataset.

            ''',
            );
          } else {
            // Perform additional logic, if any.

            onPressed?.call();

            // If page navigation is required, handle it here.

            if (pageControllerProvider != null) {
              // Access the PageController directly from the StateProvider.

              final pageController = ref.read(pageControllerProvider!);

              // Check the current page index before navigating.

              final currentPage = pageController.page?.round() ?? 0;

              // Determine the target page index based on the current page.

              int targetPage = currentPage == 0 ? 1 : currentPage;

              // Navigate to the target page.

              pageController.animateToPage(
                targetPage,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          }
        },
        child: child,
      ),
    );
  }
}
