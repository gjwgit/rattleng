/// A widget to handle multiple pages for the display widget.
//
// Time-stamp: <Wednesday 2024-07-31 08:37:29 +1000 Graham Williams>
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
// pages_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rattle/providers/page_index.dart';

class Pages extends ConsumerStatefulWidget {
  final List<Widget> children;

  const Pages({
    super.key,
    required this.children,
  });

  @override
  PagesState createState() => PagesState();
}

class PagesState extends ConsumerState<Pages> with TickerProviderStateMixin {
  late PageController _pageController;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _tabController = TabController(length: widget.children.length, vsync: this);

    // Listen to the page changes and update the TabController accordingly
    _pageController.addListener(_syncTabControllerWithPageView);
  }

  @override
  void dispose() {
    _pageController.removeListener(_syncTabControllerWithPageView);
    _pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant Pages oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.children.length != widget.children.length) {
      _initialiseControllers();
    }
  }

  void _initialiseControllers() {
    _tabController = TabController(length: widget.children.length, vsync: this);
  }

  void _syncTabControllerWithPageView() {
    // Correcting the way we access the state from pageIndexProvider
    final newPageIndex =
        _pageController.page?.round() ?? ref.read(pageIndexProvider);

    // Update only if the page index has changed
    if (newPageIndex != ref.read(pageIndexProvider)) {
      ref.read(pageIndexProvider.notifier).state = newPageIndex!;
      _tabController.index = newPageIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageIndex = ref.watch(pageIndexProvider);

    // Update page controller and tab controller whenever page index changes
    if (_pageController.hasClients &&
        pageIndex != _pageController.page?.round()) {
      _pageController.jumpToPage(pageIndex);
    }
    if (_tabController.index != pageIndex) {
      _tabController.index = pageIndex;
    }

    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              ref.read(pageIndexProvider.notifier).state = index;
              _tabController.animateTo(index);
            },
            children: widget.children,
          ),
        ),
        const SizedBox(height: 5),
        CustomPageIndicator(
          tabController: _tabController,
          currentPageIndex: pageIndex,
          onUpdateCurrentPageIndex: (index) {
            ref.read(pageIndexProvider.notifier).state = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          isOnDesktopAndWeb: _isOnDesktopAndWeb,
          pageController: _pageController,
          numOfPages: widget.children.length,
        ),
      ],
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

class CustomPageIndicator extends StatelessWidget {
  const CustomPageIndicator({
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
          Row(
            children: List<Widget>.generate(numOfPages, (index) {
              return GestureDetector(
                onTap: () {
                  onUpdateCurrentPageIndex(index);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  width: 12.0,
                  height: 12.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentPageIndex == index
                        ? colorScheme.primary
                        // Inside color for unselected dots.

                        : Colors.white,
                    border: Border.all(
                      color: currentPageIndex == index
                          ? Colors.transparent
                          // Black border for unselected dots.

                          : Colors.black,
                      width: 1.5,
                    ),
                  ),
                ),
              );
            }),
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
