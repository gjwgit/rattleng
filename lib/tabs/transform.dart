/// The Transform tab for transforming our dataset.
//
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
//
// Time-stamp: <Saturday 2024-11-23 17:35:25 +1100 Graham Williams>
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
import 'package:rattle/providers/datatype.dart';
import 'package:rattle/providers/transform.dart';
import 'package:rattle/providers/reset.dart';
import 'package:rattle/utils/debug_text.dart';

final List<Map<String, dynamic>> transformPanels = [
  {
    'title': 'Overview',
    'widget': const TransformPanel(),
  },
  {
    'title': 'Impute',
    'widget': const ImputePanel(),
  },
  {
    'title': 'Rescale',
    'widget': const RescalePanel(),
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
    debugText('  BUILD', 'TransformTab');

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
            tabs: transformPanels.map((tab) {
              return Tab(
                text: tab['title'],
              );
            }).toList(),
          ),
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
