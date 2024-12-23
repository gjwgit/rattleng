/// An ElevatedButton implementing Activity/Build initiation for Rattle.
//
// Time-stamp: <Friday 2024-12-20 16:33:38 +1100 Graham Williams>
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

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';

import 'package:rattle/providers/path.dart';
import 'package:rattle/utils/show_ok.dart';

class ActivityButton extends ConsumerWidget {
  final StateProvider<PageController>? pageControllerProvider;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Widget child;

  const ActivityButton({
    super.key,
    this.pageControllerProvider, // Optional for navigation.
    this.onPressed, // Optional for additional logic.
    this.tooltip,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MarkdownTooltip(
      message: tooltip ??
          '''

      **Build** Tap here to have the activity undertaken to build the Pages that
        will be displayed here for this Feature. Often the activity is to run
        the required R scripts which may produce output that is captured and
        displayed by Rattle, or the R script will generate plots and graphics
        that will be displayed here.

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

            // 20241220 gjw For now let's not navigate anywhere. It is not quite
            // working and the logic needs to be better thought through. If page
            // navigation is required, handle it here.

            // if (pageControllerProvider != null) {
            //   // Access the PageController directly from the StateProvider.

            //   final pageController = ref.read(pageControllerProvider!);

            // Check the current page index before navigating. 20241220 gjw
            // Comment it out for now since we are not using it to find the
            // target page for now.

            // final currentPage = pageController.page?.round() ?? 0;

            // Determine the target page index based on the current
            // page. 20241220 gjw Currently if the current page is larger than
            // the number of pages that will result after the activity, the
            // logic here does not work. The target page is too large. Until
            // we get the navigation logic working better perhaps always go to
            // the second page (the first after the overview page). That
            // should always exist and will avoid some of the odd navigation
            // issues we currently have. It is not clear that we can actually
            // know the number of available pages in here?

            // int targetPage = currentPage == 0 ? 1 : currentPage;

            // int targetPage = 1;

            // // Navigate to the target page.

            // pageController.animateToPage(
            //   targetPage,
            //   duration: const Duration(milliseconds: 300),
            //   curve: Curves.easeInOut,
            // );
            // }
          }
        },
        child: child,
      ),
    );
  }
}
