/// Main tabs page interface.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Monday 2023-08-28 09:03:32 +1000 Graham Williams>
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

import 'dart:io' show Process;

import 'package:flutter/material.dart';

import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:rattle/constants/app.dart' show appTitle;
import 'package:rattle/helpers/build_model.dart' show buildModel;
import 'package:rattle/helpers/load_dataset.dart' show loadDataset;
import 'package:rattle/helpers/r.dart';
import 'package:rattle/pages/log_tab.dart';
import 'package:rattle/pages/data_tab.dart';

/// Mapping for Tabs, title:icon:widget.

final List<Map<String, dynamic>> _tabs = [
  {
    'title': "Data",
    "icon": Icons.input,
    "widget": const DataTabPage(),
  },
  {
    'title': "Explore",
    "icon": Icons.insights,
    "widget": const Center(child: Text("EXPLORE")),
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
    'title': "Log",
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
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // The left side menu item. May not be required.

        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            debugPrint("MENU PRESSED NO ACTION YET");
          },
        ),

        // The title aligned to the left.

        title: const Text(appTitle),

        // Deploy the buttons aligned to the top right for actions.

        actions: [
          // INFO

          IconButton(
            onPressed: () {
              debugPrint(_tabs[_tabController.index]['title']);
              debugPrint(_tabs[_tabController.index]['widget']);
            },
            icon: const Icon(Icons.info),
            tooltip: "Information.",
          ),

          // RUN

          IconButton(
            key: const Key("run_button"),
            icon: const Icon(Icons.directions_run),
            onPressed: () {
              var currentTab = _tabs[_tabController.index]['title'];

              //   if (currentTab == "Data") {
              //     debugPrint("HOME PAGE: THE DATA TAB IS ACTIVE SO LOAD THE DATASET");

              //     loadDataset();
              //   } else {
              //     debugPrint("HOME PAGE: RUN NOT YET IMPLEMENTED FOR $currentTab TAB");
              //   }
              // },
              switch (currentTab) {
                case "Data":
                  {
                    debugPrint(
                      "HOME PAGE: DATA TAB ACTIVE SO LOAD THE DATASET",
                    );
                    loadDataset();
                  }
                case "Model":
                  debugPrint(
                    "HOME PAGE: MODEL TAB ACTIVE SO BUILD RPART",
                  );
                  buildModel();
                default:
                  debugPrint(
                    "HOME PAGE: RUN NOT IMPLEMENTED FOR $currentTab TAB",
                  );
              }
            },
            tooltip: "Run the current tab.",
          ),
          IconButton(
            icon: const Icon(Icons.open_in_new),
            onPressed: () async {
              debugPrint("ALL R");
              // process = await Process.start('killall', ["R"]);
              // process = await Process.start('R', ["--no-save"]);
              // process.stdout.transform(utf8.decoder).forEach(print);
              // process.stderr.transform(utf8.decoder).forEach(print);

              // cmd = 'library(tidyverse)';
              // process.stdin.writeln(cmd);
            },
            tooltip: "Start R and load tidyverse.",
            // tooltip: "Start a new project.",
          ),
          IconButton(
            icon: const Icon(Icons.open_in_browser_outlined),
            onPressed: () {
              rSource('load_demo_weather_aus_dataset');
              // cmd = "getwd()";
              // process.stdin.writeln(cmd);
              // cmd = 'ds <- read_csv("weather.csv")';
              // process.stdin.writeln(cmd);
              // cmd = 'summary(ds)';
              // process.stdin.writeln(cmd);
              // cmd = 'ds %>% ggplot(aes(x=WindDir3pm)) + geom_bar()';
              // process.stdin.writeln(cmd);
              // cmd = 'ggsave("myplot.pdf", width=11, height=7)';
              // process.stdin.writeln(cmd);
            },
            tooltip: "Load weather dataset.",
            // tooltip: "Load an existing project from file.",
          ),
          IconButton(
            icon: const Icon(Icons.save_alt_outlined),
            onPressed: () {
              Process.run("xdg-open", ["myplot.pdf"]);
            },
            tooltip: "View the plot.",
            // tooltip: "TODO Save the current project to file.",
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app_outlined),
            onPressed: () {
              debugPrint("EXIT PRESSED NO ACTION YET");
            },
            tooltip: "TODO Exit the application.",
          ),
          PopupMenuButton<Text>(
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  child: Text("TODO About Rattle"),
                ),
                const PopupMenuItem(
                  child: Text("TODO Browse Rattle Survival Guide"),
                ),
                const PopupMenuItem(
                  child: Text("TODO Browse Togaware"),
                ),
              ];
            },
          ),
        ],

        // Build the tab bar from the list of tabs, noting the tab title and
        // icon.

        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs.map((tab) {
            return Tab(
              icon: Icon(tab['icon']),
              text: tab['title'],
            );
          }).toList(),
        ),
      ),

      // Associate the Widgets with each of the bodies.

      body: TabBarView(
        controller: _tabController,
        children: _tabs.map((tab) {
          return tab['widget'] as Widget;
        }).toList(),
      ),

      // Tried this 20230827 gjw but did not work.

      // body: Container(
      //   children: [
      //     TabBarView(
      //       controller: _tabController,
      //       children: _tabs.map((tab) {
      //         return tab['widget'] as Widget;
      //       }).toList(),
      //     ),
      //     Markdown(
      //       data: 'Welcome to **RattleNG**. To begin, pick a file '
      //           '(e.g., CSV) containing your dataset, then click the '
      //           '🏃 Run button.',
      //       styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
      //     ),
      //   ],
      // ),

      // bottomNavigationBar: Row(
      //   // I am setting the height for the bottom bar but this does not really
      //   // seem to be the way to do this.
      //   children: <Widget>[
      //     Markdown(
      //       data: 'Welcome to **RattleNG**. To begin, pick a file '
      //           '(e.g., CSV) containing your dataset, then click the '
      //           '🏃 Run button.',
      //       styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
      //     ),
      //   ],
      // ),

      // ignore: sized_box_for_whitespace
      bottomNavigationBar: Container(
        // I am setting the height for the bottom bar but this does not really
        // seem to be the way to do this.
        height: 50,
        child: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Markdown(
            data: 'Welcome to **RattleNG**. To begin, pick a file '
                '(e.g., CSV) containing your dataset, then click the '
                '🏃 Run button.',
            styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
          ),
        ),
      ),
    );
  }
}
