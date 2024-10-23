/// A page navigation widget.
//
// Time-stamp: <Thursday 2024-10-17 14:01:05 +1100 Graham Williams>
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
  PageViewerState createState() => PageViewerState();
}

class PageViewerState extends State<PageViewer> {
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
