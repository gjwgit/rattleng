/// The Transform tab for transforming our dataset.
//
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
//
// Time-stamp: <Wednesday 2024-07-31 08:38:50 +1000 Graham Williams>
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
/// Authors: Graham Williams

library;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/features/transform/panel.dart';
import 'package:rattle/features/rescale/panel.dart';
import 'package:rattle/features/impute/panel.dart';
import 'package:rattle/features/recode/panel.dart';
import 'package:rattle/features/cleanup/panel.dart';
import 'package:rattle/providers/transform.dart';

final List<Map<String, dynamic>> transformPanels = [
  {
    'title': 'Overview',
    'widget': const TransformPanel(),
  },
  {
    'title': 'Rescale',
    'widget': const RescalePanel(),
  },
  {
    'title': 'Impute',
    'widget': const ImputePanel(),
  },
  {
    'title': 'Recode',
    'widget': const RecodePanel(),
  },
  {
    'title': 'Cleanup',
    'widget': const CleanupPanel(),
  },
];

class TransformTabs extends ConsumerStatefulWidget {
  const TransformTabs({super.key});

  @override
  ConsumerState<TransformTabs> createState() => _TransformTabsState();
}

class _TransformTabsState extends ConsumerState<TransformTabs>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: transformPanels.length, vsync: this);

    _tabController.addListener(() {
      ref.read(transformProvider.notifier).state =
          transformPanels[_tabController.index]['title'];
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
    debugPrint('TRANSFORM: Rebuild.');

    return Column(
      children: [
        TabBar(
          unselectedLabelColor: Colors.grey,
          controller: _tabController,
          tabs: transformPanels.map((tab) {
            return Tab(
              text: tab['title'],
            );
          }).toList(),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: transformPanels.map((tab) {
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
