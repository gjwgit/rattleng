/// Identify the main app tabs: title, icon and widget.
//
// Time-stamp: <Thursday 2024-06-13 16:14:23 +1000 Graham Williams>
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
/// Authors: <AUTHORS>

library;

// Group imports by dart, flutter, packages, local. Then alphabetically.
import 'package:flutter/material.dart';

import 'package:rattle/features/dataset/tab.dart';
import 'package:rattle/features/debug/tab.dart';
import 'package:rattle/features/explore/tab.dart';
import 'package:rattle/features/model/tab.dart';
import 'package:rattle/features/script/tab.dart';
import 'package:rattle/r/console.dart';

final List<Map<String, dynamic>> homeTabs = [
  {
    'title': 'Dataset',
    'icon': Icons.input,
    'widget': const DatasetTab(),
  },
  {
    'title': 'Explore',
    'icon': Icons.insights,
    'widget': const ExploreTab(),
  },
  {
    'title': 'Wrangle',
    'icon': Icons.transform,
    'widget': const Center(child: Text('WRANGLE')),
  },
  {
    'title': 'Model',
    'icon': Icons.model_training,
    'widget': const ModelTab(),
  },
  {
    'title': 'Evaluate',
    'icon': Icons.leaderboard,
    'widget': const Center(child: Text('EVALUATE')),
  },
  {
    'title': 'Console',
    'icon': Icons.terminal,
    'widget': const RConsole(),
  },
  {
    'title': 'Script',
    'icon': Icons.code,
    'widget': const ScriptTab(),
  },
  {
    'title': 'Debug',
    'icon': Icons.work,
    'widget': const DebugTab(),
  },
];
