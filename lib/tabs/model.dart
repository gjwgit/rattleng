/// Model tab for home page.
//
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
//
// Time-stamp: <Friday 2024-07-19 09:34:24 +1000 Graham Williams>
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
    'title': 'Word Cloud',
    'widget': const WordCloudPanel(),
  },
  {
    'title': 'SVM',
    'widget': const SvmPanel(),
  },
  {
    'title': 'Linear',
    'widget': const LinearPanel(),
  },
  {
    'title': 'Neural',
    'widget': const NeuralPanel(),
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: modelPanels.length, vsync: this);

    _tabController.addListener(() {
      ref.read(modelProvider.notifier).state =
          modelPanels[_tabController.index]['title'];
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
    debugPrint('modeltab rebuild.');

    return Column(
      children: [
        TabBar(
          unselectedLabelColor: Colors.grey,
          controller: _tabController,
          tabs: modelPanels.map((tab) {
            return Tab(
              text: tab['title'],
            );
          }).toList(),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: modelPanels.map((tab) {
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
