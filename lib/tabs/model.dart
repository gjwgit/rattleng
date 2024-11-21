/// Model tab for home page.
//
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
//
// Time-stamp: <Thursday 2024-11-21 14:30:37 +1100 Graham Williams>
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
import 'package:rattle/constants/app.dart';

import 'package:rattle/features/model/panel.dart';
import 'package:rattle/features/cluster/panel.dart';
import 'package:rattle/features/forest/panel.dart';
import 'package:rattle/features/tree/panel.dart';
import 'package:rattle/features/association/panel.dart';
import 'package:rattle/features/boost/panel.dart';
import 'package:rattle/features/svm/panel.dart';
import 'package:rattle/features/linear/panel.dart';
import 'package:rattle/features/neural/panel.dart';
import 'package:rattle/features/wordcloud/panel.dart';
import 'package:rattle/providers/model.dart';
import 'package:rattle/providers/path.dart';
import 'package:rattle/utils/debug_text.dart';

final List<Map<String, dynamic>> modelPanels = [
  {
    'title': 'Overview',
    'widget': const ModelPanel(),
  },
  {
    'title': 'Cluster',
    'widget': const ClusterPanel(),
  },
  {
    'title': 'Associations',
    'widget': const AssociationPanel(),
  },
  {
    'title': 'Linear',
    'widget': const LinearPanel(),
  },
  {
    'title': 'Neural',
    'widget': const NeuralPanel(),
  },
  {
    'title': 'Tree',
    'widget': const TreePanel(),
  },
  {
    'title': 'Forest',
    'widget': const ForestPanel(),
  },
  {
    'title': 'Boost',
    'widget': const BoostPanel(),
  },
  {
    'title': 'SVM',
    'widget': const SvmPanel(),
  },
  {
    'title': 'Word Cloud',
    'widget': const WordCloudPanel(),
  },
];

// TODO 20230916 gjw DOES THIS NEED TO BE STATEFUL?

class ModelTabs extends ConsumerStatefulWidget {
  const ModelTabs({super.key});

  @override
  ConsumerState<ModelTabs> createState() => _ModelTabsState();
}

class _ModelTabsState extends ConsumerState<ModelTabs>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<Map<String, dynamic>> filteredModelPanels;

  @override
  void initState() {
    super.initState();

    // Get the path from the provider
    String currentPath = ref.read(pathProvider);

    // Filter tabs based on the file type in the path
    if (currentPath.endsWith('.txt')) {
      // Only show the Word Cloud tab for .txt files
      filteredModelPanels =
          modelPanels.where((panel) => panel['title'] == 'Word Cloud').toList();
    } else if (currentPath.endsWith('.csv') || currentPath == weatherDemoFile) {
      // For csv files and demo, show all tabs except the Word Cloud tab
      filteredModelPanels =
          modelPanels.where((panel) => panel['title'] != 'Word Cloud').toList();
    } else {
      // For other files including no files
      filteredModelPanels = modelPanels;
    }

    // Initialize the TabController with the filtered panels
    _tabController =
        TabController(length: filteredModelPanels.length, vsync: this);

    _tabController.addListener(() {
      ref.read(modelProvider.notifier).state =
          filteredModelPanels[_tabController.index]['title'];
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
    debugText('  BUILD', 'ModelTabs');
    debugPrint(ref.read(pathProvider));

    return Column(
      children: [
        TabBar(
          unselectedLabelColor: Colors.grey,
          controller: _tabController,
          tabs: filteredModelPanels.map((tab) {
            return Tab(
              text: tab['title'],
            );
          }).toList(),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: filteredModelPanels.map((tab) {
              return tab['widget'] as Widget;
            }).toList(),
          ),
        ),
      ],
    );
  }

  // Disable the automatic rebuild everytime we switch to the model tab.
  // TODO 20240604 gjw WHY? ALWAYS GOOD TO EXPLAIN WHY
  @override
  bool get wantKeepAlive => true;
}
