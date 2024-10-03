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
  int targetPage = (currentPage >= 2 && currentPage <= 4) ? currentPage : 1;

  // Navigate to the target page.
  pageController.animateToPage(
    targetPage,
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeInOut,
  );
}
