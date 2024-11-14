/// Widget to display the Forest introduction or built tree.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Tuesday 2024-10-15 20:09:06 +1100 Graham Williams>
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
/// Authors: Graham Williams

library;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/markdown.dart';
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/widgets/page_viewer.dart';
import 'package:rattle/utils/show_markdown_file.dart';

/// The FOREST panel displays the instructions and then the build output.

class EvaluateDisplay extends ConsumerStatefulWidget {
  const EvaluateDisplay({super.key});

  @override
  ConsumerState<EvaluateDisplay> createState() => _EvaluateDisplayState();
}

class _EvaluateDisplayState extends ConsumerState<EvaluateDisplay> {
  @override
  Widget build(BuildContext context) {
    final pageController = ref.watch(
      evaluatePageControllerProvider,
    ); // Get the PageController from Riverpod

    List<Widget> pages = [showMarkdownFile(evaluateIntroFile, context)];

    return PageViewer(
      pageController: pageController,
      pages: pages,
    );
  }
}
