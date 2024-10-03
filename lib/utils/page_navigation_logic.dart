/// Function to handle page navigation to make sure it stays on the correct page.
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
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
///
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void handlePageNavigation(
  BuildContext context,
  WidgetRef ref,
  StateProvider<PageController>
      pageControllerProvider, // Accepts StateProvider<PageController>
  VoidCallback
      additionalLogic, // For specific logic like rSource or buildAction
) {
  // Access the PageController directly from the StateProvider.

  final pageController = ref.read(pageControllerProvider);

  // Check the current page index before navigating.

  final currentPage = pageController.page?.round() ?? 0;

  // Execute any additional logic specific to the button.

  additionalLogic();

  // Determine the target page index based on the current page.

  int targetPage = currentPage >= 2 ? currentPage : 1;

  // Navigate to the target page.

  pageController.animateToPage(
    targetPage,
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeInOut,
  );
}
