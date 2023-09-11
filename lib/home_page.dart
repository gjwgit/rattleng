/// The main tabs-based page interface.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Monday 2023-09-11 14:13:50 +1000 Graham Williams>
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

import 'package:flutter/material.dart';

import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:rattle/constants/app.dart';
import 'package:rattle/helpers/build_model.dart' show buildModel;
import 'package:rattle/helpers/load_dataset.dart' show loadDataset;
import 'package:rattle/tabs/log_tab.dart';
import 'package:rattle/tabs/data_tab.dart';
import 'package:rattle/tabs/tab_utils.dart' show processTab;
import 'package:rattle/widgets/r_console.dart';

/// Define a mapping for the tabs in the GUI on to title:icon:widget.

final List<Map<String, dynamic>> tabs = [
  {
    'title': "Data",
    "icon": Icons.input,
    "widget": const DataTab(),
  },
  {
    'title': "Explore",
    "icon": Icons.insights,
    "widget": Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Image.asset("assets/images/myplot.png"),
      ),
    ),
  },
  {
    'title': "Test",
    "icon": Icons.task,
    "widget": const Center(child: Text("TEST")),
  },
  {
    'title': "Transform",
    "icon": Icons.transform,
    "widget": const Center(child: Text("TRANSFORM")),
  },
  {
    'title': "Model",
    "icon": Icons.model_training,
    "widget": const Center(child: Text("MODEL")),
  },
  {
    'title': "Evaluate",
    "icon": Icons.leaderboard,
    "widget": const Center(child: Text("EVALUATE")),
  },
  {
    'title': "Console",
    "icon": Icons.terminal,
//    "widget": TerminalView(terminal),
    "widget": const RConsole(),
  },
  {
    'title': "Script",
    "icon": Icons.code,
    "widget": const LogTab(),
  },
];

class RattleHomePage extends StatefulWidget {
  const RattleHomePage({Key? key}) : super(key: key);

  @override
  RattleHomePageState createState() => RattleHomePageState();
}

class RattleHomePageState extends State<RattleHomePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // The title aligned to the left.

        title: const Text(appTitle),

        // Deploy the buttons aligned to the top right for actions.

        actions: [
          // RUN

          IconButton(
            key: const Key("run_button"),
            icon: const Icon(
              Icons.directions_run,
              color: Colors.yellow,
            ),
            onPressed: () {
              processTab(tabs[tabController.index]['title']);
            },
            tooltip: "Run the current tab.",
          ),

          // RESET

          IconButton(
            icon: const Icon(
              Icons.autorenew,
              color: Colors.grey,
            ),
            onPressed: () {
              debugPrint("RESET PRESSED NO ACTION YET");
            },
            tooltip: "TODO: Reset to start a new project.",
          ),

          // LOAD PROJECT

          IconButton(
            icon: const Icon(
              Icons.download,
              color: Colors.grey,
            ),
            onPressed: () {
              debugPrint("LOAD PRESSED NO ACTION YET");
            },
            tooltip: "TODO: Load an existing project from file.",
          ),

          // SAVE PROJECT

          IconButton(
            icon: const Icon(
              Icons.upload,
              color: Colors.grey,
            ),
            onPressed: () {
              debugPrint("SAVE PRESSED NO ACTION YET");
            },
            tooltip: "TODO: Save the current project to file.",
          ),

          // INFO

          IconButton(
            onPressed: () {
              debugPrint("TAB is ${tabs[tabController.index]['title']}");
            },
            icon: const Icon(
              Icons.info,
              color: Colors.blue,
            ),
            tooltip: "FOR NOW: Report the current TAB.",
          ),
        ],

        // Build the tab bar from the list of tabs, noting the tab title and
        // icon.

        bottom: TabBar(
          controller: tabController,
          indicatorColor: Colors.yellow,
          labelColor: Colors.yellow,
          unselectedLabelColor: Colors.grey,
          // dividerColor: Colors.green,
          tabAlignment: TabAlignment.fill,
          isScrollable: false,
          tabs: tabs.map((tab) {
            return Tab(
              icon: Icon(tab['icon']),
              text: tab['title'],
            );
          }).toList(),
        ),
      ),

      // Associate the Widgets with each of the bodies.

      body: TabBarView(
        controller: tabController,
        children: tabs.map((tab) {
          return tab['widget'] as Widget;
        }).toList(),
      ),

      // ignore: sized_box_for_whitespace
      bottomNavigationBar: Container(
        // I am setting the height for the bottom bar but this does not really
        // seem to be the way to do this.
        height: 50,
        padding: const EdgeInsets.only(left: 0),
        color: statusBarColour,
        child: Markdown(
          selectable: true,
          data: statusWelcomeMsg,
          styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
        ),
      ),
    );
  }
}
