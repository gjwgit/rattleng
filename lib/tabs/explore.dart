/// The Explore tab for publishing on the app home page.
//
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
//
// Time-stamp: <Friday 2024-06-14 14:58:36 +1000 Graham Williams>
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

import 'package:rattle/panels/summary/panel.dart';
import 'package:rattle/panels/visual/panel.dart';
import 'package:rattle/panels/missing/panel.dart';
import 'package:rattle/panels/correlation/panel.dart';
import 'package:rattle/panels/tests/panel.dart';
import 'package:rattle/panels/interactive/panel.dart';
//TODO import 'package:rattle/panels/wordcloud/panel.dart';
import 'package:rattle/providers/explore.dart';

final List<Map<String, dynamic>> explorePanels = [
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
    _tabController = TabController(length: explorePanels.length, vsync: this);

    _tabController.addListener(() {
      ref.read(exploreProvider.notifier).state =
          explorePanels[_tabController.index]['title'];
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
    debugPrint('ExploreTab: Rebuild.');

    return Column(
      children: [
        TabBar(
          unselectedLabelColor: Colors.grey,
          controller: _tabController,
          tabs: explorePanels.map((tab) {
            return Tab(
              text: tab['title'],
            );
          }).toList(),
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
