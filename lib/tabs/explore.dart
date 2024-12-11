/// The Explore tab for publishing on the app home page.
//
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
//
// Time-stamp: <Saturday 2024-11-23 17:15:47 +1100 Graham Williams>
//
// Licensed under the GNU General Public License, Version 3 (the "License");
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
/// Authors: Graham Williams, Yixiang Yin

library;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/features/explore/panel.dart';
import 'package:rattle/features/summary/panel.dart';
import 'package:rattle/features/visual/panel.dart';
import 'package:rattle/features/missing/panel.dart';
import 'package:rattle/features/correlation/panel.dart';
import 'package:rattle/features/tests/panel.dart';
import 'package:rattle/features/interactive/panel.dart';
import 'package:rattle/providers/datatype.dart';
import 'package:rattle/providers/explore.dart';
import 'package:rattle/providers/reset.dart';
import 'package:rattle/utils/debug_text.dart';

final List<Map<String, dynamic>> explorePanels = [
  {
    'title': 'Overview',
    'widget': const ExplorePanel(),
  },
  {
    'title': 'Summary',
    'widget': const SummaryPanel(),
  },
  {
    'title': 'Visual',
    'widget': const VisualPanel(),
  },
  {
    'title': 'Missing',
    'widget': const MissingPanel(),
  },
  {
    'title': 'Correlation',
    'widget': const CorrelationPanel(),
  },
  {
    'title': 'Tests',
    'widget': const TestsPanel(),
  },
  {
    'title': 'Interactive',
    'widget': const InteractivePanel(),
  },
  // TODO ADD WORDCLOUD HERE
  // {
  //   'title': 'Word Cloud',
  //   'widget': const WordCloudPanel(),
  // },
];

class ExploreTabs extends ConsumerStatefulWidget {
  const ExploreTabs({super.key});

  @override
  ConsumerState<ExploreTabs> createState() => _ExploreTabsState();
}

class _ExploreTabsState extends ConsumerState<ExploreTabs>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: explorePanels.length, vsync: this);

    _tabController.addListener(() {
      ref.read(exploreProvider.notifier).state =
          explorePanels[_tabController.index]['title'];
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    debugText('  BUILD', 'ExploreTab');

    // Listen to isResetProvider and reset tabController to index 0 if true.

    final isReset = ref.watch(isResetProvider);

    if (isReset) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _tabController.animateTo(0);
        // Reset the flag.

        ref.read(isResetProvider.notifier).state = false;
      });
    }

    return Column(
      children: [
        // 20241123 gjw Ignore the features if the data type of the loaded
        // dataset is not 'table'. The features are implemented assuming a table
        // as the dataset.

        IgnorePointer(
          ignoring: !['', 'table'].contains(ref.watch(datatypeProvider)),
          child: TabBar(
            unselectedLabelColor: Colors.grey,
            controller: _tabController,
            tabs: explorePanels.map((tab) {
              return Tab(
                text: tab['title'],
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: explorePanels.map((tab) {
              return tab['widget'] as Widget;
            }).toList(),
          ),
        ),
      ],
    );
  }

  // Disable the automatic rebuild everytime we switch to the explore tab.
  // TODO 20240604 gjw WHY? NEED TO EXPLAIN WHY HERE
  @override
  bool get wantKeepAlive => true;
}
