/// SVM tab made up of config and panel widgets.
//
// Time-stamp: <Friday 2024-07-19 09:29:27 +1000 Graham Williams>
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
/// Authors: Graham Williams

library;

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'package:flutter/material.dart';

import 'package:rattle/constants/markdown.dart';
import 'package:rattle/utils/show_markdown_file.dart';

/// The SVM feature supports Svm rule analysis.

class TransformPanel extends StatelessWidget {
  const TransformPanel({super.key});

  @override
  Widget build(BuildContext context) {
    // As per the RattleNG pattern, a Tab consists of a Config bar and the
    // results Display().

    return showMarkdownFile(transformIntroFile, context);
  }
}
