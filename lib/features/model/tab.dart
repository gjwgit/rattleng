/// Model tab for home page.
//
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
//
// Time-stamp: <Thursday 2024-06-13 17:24:35 +1000 Graham Williams>
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

import 'package:rattle/features/model/cluster/tab.dart';
import 'package:rattle/features/model/forest/tab.dart';
import 'package:rattle/features/model/tree/tab.dart';
import 'package:rattle/features/model/association/tab.dart';
import 'package:rattle/features/model/boost/tab.dart';
import 'package:rattle/features/model/svm/tab.dart';
import 'package:rattle/features/model/linear/tab.dart';
import 'package:rattle/features/model/neural/tab.dart';
import 'package:rattle/features/model/wordcloud/tab.dart';
import 'package:rattle/provider/model.dart';

final List<Map<String, dynamic>> modelTabs = [
  {
    'title': 'Cluster',
    'widget': const ClusterTab(),
  },
  {
    'title': 'Associations',
    'widget': const AssociationTab(),
  },
  {
    'title': 'Tree',
    'widget': const TreeTab(),
  },
  {
    'title': 'Forest',
    'widget': const ForestTab(),
  },
  {
    'title': 'Boost',
    'widget': const BoostTab(),
  },
  {
    'title': 'Word Cloud',
    'widget': const WordCloudTab(),
  },
  {
    'title': 'SVM',
    'widget': const SvmTab(),
  },
  {
    'title': 'Linear',
    'widget': const LinearTab(),
  },
  {
    'title': 'Neural',
    'widget': const NeuralTab(),
  },
];

// TODO 20230916 gjw DOES THIS NEED TO BE STATEFUL?

class ModelTab extends ConsumerStatefulWidget {
  const ModelTab({super.key});

  @override
  ConsumerState<ModelTab> createState() => _ModelTabState();
}

class _ModelTabState extends ConsumerState<ModelTab>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: modelTabs.length, vsync: this);

    _tabController.addListener(() {
      ref.read(modelProvider.notifier).state =
          modelTabs[_tabController.index]['title'];
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
          tabs: modelTabs.map((tab) {
            return Tab(
              text: tab['title'],
            );
          }).toList(),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: modelTabs.map((tab) {
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
