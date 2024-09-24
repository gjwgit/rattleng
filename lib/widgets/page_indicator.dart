import 'package:flutter/material.dart';

class NewPageIndicator extends StatelessWidget {
  const NewPageIndicator({
    super.key,
    required this.pageController,
    required this.currentPageIndex,
    required this.onUpdateCurrentPageIndex,
    required this.numOfPages,
  });

  final int numOfPages;
  final int currentPageIndex;
  final PageController pageController;
  final void Function(int) onUpdateCurrentPageIndex;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Left arrow button to go to the previous page
          IconButton(
            splashRadius: 16.0,
            padding: EdgeInsets.zero,
            onPressed: () {
              if (currentPageIndex > 0) {
                onUpdateCurrentPageIndex(currentPageIndex - 1);
              }
            },
            icon: const Icon(
              Icons.arrow_left_rounded,
              size: 32.0,
            ),
          ),
          // Page indicators (dots)
          Row(
            children: List<Widget>.generate(numOfPages, (index) {
              return GestureDetector(
                onTap: () {
                  onUpdateCurrentPageIndex(
                      index); // Update the page when a dot is tapped
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  width: 12.0,
                  height: 12.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentPageIndex == index
                        ? colorScheme.primary
                        : Colors.white,
                    border: Border.all(
                      color: currentPageIndex == index
                          ? Colors.transparent
                          : Colors.black,
                      width: 1.5,
                    ),
                  ),
                ),
              );
            }),
          ),
          // Right arrow button to go to the next page
          IconButton(
            splashRadius: 16.0,
            padding: EdgeInsets.zero,
            onPressed: () {
              if (currentPageIndex < numOfPages - 1) {
                onUpdateCurrentPageIndex(currentPageIndex + 1);
              }
            },
            icon: const Icon(
              Icons.arrow_right_rounded,
              size: 32.0,
            ),
          ),
        ],
      ),
    );
  }
}
