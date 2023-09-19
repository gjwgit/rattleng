/// The main tabs-based page interface.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Wednesday 2023-09-20 09:39:44 +1000 Graham Williams>
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

import 'package:rattle/constants/app.dart';
import 'package:rattle/dataset/tab.dart';
import 'package:rattle/model/tab.dart';
import 'package:rattle/script/tab.dart';
import 'package:rattle/helpers/process_tab.dart';
import 'package:rattle/r/console.dart';
import 'package:rattle/widgets/status_bar.dart';
import 'package:rattle/widgets/test_widget.dart';

/// Define a mapping for the tabs in the GUI on to title:icon:widget.

final List<Map<String, dynamic>> tabs = [
  {
    'title': "Dataset",
    "icon": Icons.input,
    "widget": const DatasetTab(),
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
    "widget": const TestWidget(),
    // "widget": const Center(child: Text("TEST")),
  },
  {
    'title': "Transform",
    "icon": Icons.transform,
    "widget": const Center(child: Text("TRANSFORM")),
  },
  {
    'title': "Model",
    "icon": Icons.model_training,
    // "widget": const Center(child: Text("MODEL")),
    "widget": const ModelTab(),
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
    "widget": const ScriptTab(),
  },
];

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>
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
              color: Colors.grey,
            ),
            onPressed: () {
              debugPrint("RUN PRESSED NO ACTION AT THIS TIME");
              // KEEP OPEN FOR NOW FOR THE MODEL TAB.
              processTab(tabs[tabController.index]['title']);
            },
            tooltip:
                "NO LONGER ACTIVE AT LEAST FOR NOW. WAS Run the current tab.",
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
          //indicatorColor: Colors.yellow,
          //labelColor: Colors.yellow,
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
      bottomNavigationBar: const StatusBar(),
    );
  }
}
