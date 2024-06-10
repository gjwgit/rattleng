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
