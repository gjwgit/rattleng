import 'package:flutter/material.dart';
import 'package:rattle/widgets/page_indicator.dart';

class PageViewer extends StatefulWidget {
  final PageController pageController;
  final List<Widget> pages;

  const PageViewer({
    super.key,
    required this.pageController,
    required this.pages,
  });

  @override
  _PageViewerState createState() => _PageViewerState();
}

class _PageViewerState extends State<PageViewer> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // PageView takes up most of the space.
        Expanded(
          child: PageView(
            // Attach the PageController passed from the widget.
            controller: widget.pageController,
            onPageChanged: (index) {
              setState(() {
                // Update the current page index.
                _currentPage = index;
              });
            },
            children: widget.pages,
          ),
        ),
        // NewPageIndicator placed at the bottom of the PageView.
        NewPageIndicator(
          // The current page index.
          currentPageIndex: _currentPage,
          // Pass the PageController.
          pageController: widget.pageController,
          // Total number of pages.
          numOfPages: widget.pages.length,
          onUpdateCurrentPageIndex: (index) {
            setState(() {
              // Update the current page index.
              _currentPage = index;
            });
            widget.pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
        ),
      ],
    );
  }
}
