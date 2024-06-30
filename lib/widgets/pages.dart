/// A widget to handle multiple pages for the display widget.
//
// Time-stamp: <Sunday 2024-06-30 12:44:39 +1000 Graham Williams>
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
/// Authors: Yixiang Yin

library;

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'package:flutter/material.dart';

class Pages extends StatefulWidget {
  final List<Widget> children;

  const Pages({
    super.key,
    required this.children,
  });

  @override
  PagesState createState() => PagesState();
}

class PagesState extends State<Pages> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // By default, show the result page after build.
    // TODO yyx 20240627 not run after the second build.
    // _pageController = PageController(initialPage: widget.children.length - 1);
    _pageController = PageController(initialPage: 0);
    debugPrint('PAGE CONTROLLER: ${widget.children.length}');
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.animateToPage(
        _currentPage - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNextPage() {
    if (_currentPage < widget.children.length - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void goToResultPage() {
    debugPrint('go to result page');
    // TODO yyx 20240624 might need change when we have more pages than 2.
    _goToNextPage();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.arrow_left,
            color: _currentPage > 0 ? Colors.black : Colors.grey,
            size: 32,
          ),
          onPressed: _currentPage > 0 ? _goToPreviousPage : null,
        ),
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: widget.children,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.arrow_right,
            size: 32,
            color: _currentPage < widget.children.length - 1
                ? Colors.black
                : Colors.grey,
          ),
          onPressed:
              _currentPage < widget.children.length - 1 ? _goToNextPage : null,
        ),
      ],
    );
  }
}
