/// The Explore tab for publishing on the app home page.
//
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
//
// Time-stamp: <Monday 2024-06-10 10:37:28 +1000 Graham Williams>
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

import 'package:rattle/features/explore/summary/tab.dart';
import 'package:rattle/features/explore/visual/tab.dart';
import 'package:rattle/features/explore/missing/tab.dart';
import 'package:rattle/features/explore/correlation/tab.dart';
import 'package:rattle/features/explore/tests/tab.dart';
import 'package:rattle/features/explore/interactive/tab.dart';
//import 'package:rattle/features/explore/wordcloud/tab.dart';
import 'package:rattle/provider/explore.dart';

final List<Map<String, dynamic>> exploreTabs = [
  {
    'title': 'Summary',
    'widget': const SummaryTab(),
  },
  {
    'title': 'Visual',
    'widget': const VisualTab(),
  },
  {
    'title': 'Missing',
    'widget': const MissingTab(),
  },
  {
    'title': 'Correlation',
    'widget': const CorrelationTab(),
  },
  {
    'title': 'Tests',
    'widget': const TestsTab(),
  },
  {
    'title': 'Interactive',
    'widget': const InteractiveTab(),
  },
  // {
  //   'title': 'Word Cloud',
  //   'widget': const WordCloudTab(),
  // },
];

class ExploreTab extends ConsumerStatefulWidget {
  const ExploreTab({super.key});

  @override
  ConsumerState<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends ConsumerState<ExploreTab>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: exploreTabs.length, vsync: this);

    _tabController.addListener(() {
      ref.read(exploreProvider.notifier).state =
          exploreTabs[_tabController.index]['title'];
      debugPrint('Selected tab: ${_tabController.index}');
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
    debugPrint('exploretab rebuild.');

    return Column(
      children: [
        TabBar(
          unselectedLabelColor: Colors.grey,
          controller: _tabController,
          tabs: exploreTabs.map((tab) {
            return Tab(
              text: tab['title'],
            );
          }).toList(),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: exploreTabs.map((tab) {
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
