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
    _pageController = PageController(initialPage: 0);
    _tabController = TabController(length: widget.children.length, vsync: this);
    debugPrint('PAGE CONTROLLER: ${widget.children.length}');
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _tabController.dispose();
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
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // IconButton(
        //   icon: Icon(
        //     Icons.arrow_left,
        //     color: _currentPage > 0 ? Colors.black : Colors.grey,
        //     size: 32,
        //   ),
        //   onPressed: _currentPage > 0 ? _goToPreviousPage : null,
        // ),
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
        PageIndicator(tabController: _tabController, currentPageIndex: _currentPage, onUpdateCurrentPageIndex: _updateCurrentPageIndex, isOnDesktopAndWeb: _isOnDesktopAndWeb),
        // IconButton(
        //   icon: Icon(
        //     Icons.arrow_right,
        //     size: 32,
        //     color: _currentPage < widget.children.length - 1
        //         ? Colors.black
        //         : Colors.grey,
        //   ),
        //   onPressed:
        //       _currentPage < widget.children.length - 1 ? _goToNextPage : null,
        // ),
      ],
    );
  }
  
    void _updateCurrentPageIndex(int index) {
    _tabController.index = index;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
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
    required this.currentPageIndex,
    required this.onUpdateCurrentPageIndex,
    required this.isOnDesktopAndWeb,
  });

  final int currentPageIndex;
  final TabController tabController;
  final void Function(int) onUpdateCurrentPageIndex;
  final bool isOnDesktopAndWeb;

  @override
  Widget build(BuildContext context) {
    if (!isOnDesktopAndWeb) {
      return const SizedBox.shrink();
    }
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
// This error occurs when you click the right arrow at the last page
//     The following assertion was thrown while handling a gesture:
// 'package:flutter/src/material/tab_controller.dart': Failed assertion: line 193 pos 12: 'value >= 0
// && (value < length || length == 0)': is not true.

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            splashRadius: 16.0,
            padding: EdgeInsets.zero,
            onPressed: () {
              if (currentPageIndex == 0) {
                return;
              }
              onUpdateCurrentPageIndex(currentPageIndex - 1);
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
              if (currentPageIndex == 2) {
                return;
              }
              onUpdateCurrentPageIndex(currentPageIndex + 1);
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
