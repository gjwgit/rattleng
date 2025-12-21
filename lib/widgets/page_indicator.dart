/// A new page indicator.
//
// Time-stamp: "Saturday 2025-08-16 06:33:35 +1000 Graham Williams"
//
/// Copyright (C) 2024, Togaware Pty Ltd
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://opensource.org/license/gpl-3-0
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
// this program.  If not, see <https://opensource.org/license/gpl-3-0>.
///
/// Authors: Kevin Wang

library;

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
            icon: const Icon(Icons.arrow_left_rounded, size: 32.0),
          ),
          // Page indicators (dots)
          Row(
            children: List<Widget>.generate(numOfPages, (index) {
              return GestureDetector(
                onTap: () {
                  onUpdateCurrentPageIndex(
                    index,
                  ); // Update the page when a dot is tapped
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
            icon: const Icon(Icons.arrow_right_rounded, size: 32.0),
          ),
        ],
      ),
    );
  }
}
