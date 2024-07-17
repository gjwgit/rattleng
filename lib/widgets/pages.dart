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
import 'package:flutter/foundation.dart';

class Pages extends StatefulWidget {
  final List<Widget> children;

  const Pages({
    super.key,
    required this.children,
  });

  @override
  PagesState createState() => PagesState();
}

class PagesState extends State<Pages> with TickerProviderStateMixin {
  // in order to use the 'this' as vsync below
  late PageController _pageController;
  late TabController _tabController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // By default, show the result page after build.
    // TODO yyx 20240627 not run after the second build.
    // _pageController = PageController(initialPage: widget.children.length - 1);
    // if (widget.children.length == 2) {
    //   _currentPage = 1;
    // }
    _pageController = PageController(initialPage: _currentPage);
    _tabController = TabController(length: widget.children.length, vsync: this);
    debugPrint('PAGE CONTROLLER: ${widget.children.length}');
  }

  // We need to initialise the tab controller
  // because the number of pages in it is not changed after the number of pages increase.
  @override
  void didUpdateWidget(covariant Pages oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.children.length != widget.children.length) {
            _initialiseControllers();
    }
  }

  void _initialiseControllers() {
    // _pageController = PageController(initialPage: 0);
    _tabController = TabController(length: widget.children.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Number of pages is ${widget.children.length}');
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // I didn't use expanded here because we assume expanded is used at each tab file.
        PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          children: widget.children,
        ),
        PageIndicator(
          tabController: _tabController,
          currentPageIndex: _currentPage,
          onUpdateCurrentPageIndex: _updateCurrentPageIndex,
          isOnDesktopAndWeb: _isOnDesktopAndWeb,
          pageController: _pageController,
          numOfPages: widget.children.length,
        ),
      ],
    );
  }

  void _updateCurrentPageIndex(int index) {
    debugPrint('in the tab controller it says there are ${_tabController.length} pages');
    _tabController.index = index;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  bool get _isOnDesktopAndWeb {
    if (kIsWeb) {
      return true;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return true;
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
        return false;
    }
  }
}

/// Page indicator for desktop and web platforms.
///
/// On Desktop and Web, drag gesture for horizontal scrolling in a PageView is disabled by default.
/// You can defined a custom scroll behavior to activate drag gestures,
/// see https://docs.flutter.dev/release/breaking-changes/default-scroll-behavior-drag.
///
/// In this sample, we use a TabPageSelector to navigate between pages,
/// in order to build natural behavior similar to other desktop applications.
class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.tabController,
    required this.pageController,
    required this.currentPageIndex,
    required this.onUpdateCurrentPageIndex,
    required this.isOnDesktopAndWeb,
    required this.numOfPages,
  });

  final int numOfPages;
  final int currentPageIndex;
  final TabController tabController;
  final PageController pageController;
  final void Function(int) onUpdateCurrentPageIndex;
  final bool isOnDesktopAndWeb;

  @override
  Widget build(BuildContext context) {
    if (!isOnDesktopAndWeb) {
      return const SizedBox.shrink();
    }
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
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
          TabPageSelector(
            controller: tabController,
            color: colorScheme.surface,
            selectedColor: colorScheme.primary,
          ),
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
