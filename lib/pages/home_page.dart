/// Main tabs page interface.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Wednesday 2023-08-23 14:50:51 +1000 Graham Williams>
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
import 'dart:convert' show utf8;

import 'package:flutter/material.dart';

import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:rattle/helpers/load_dataset.dart';
import 'package:rattle/helpers/r.dart';
import 'package:rattle/pages/log_tab.dart';
import 'package:rattle/pages/data_tab.dart';

/// Mapping for Tabs, title:icon:widget.

final List<Map<String, dynamic>> _tabs = [
  {'title': "Data", "icon": Icons.input, "widget": DataTabPage()},
  {
    'title': "Explore",
    "icon": Icons.insights,
    "widget": Center(child: Text("EXPLORE"))
  },
  {'title': "Test", "icon": Icons.task, "widget": Center(child: Text("TEST"))},
  {
    'title': "Transform",
    "icon": Icons.transform,
    "widget": Center(child: Text("TRANSFORM"))
  },
  {
    'title': "Model",
    "icon": Icons.model_training,
    "widget": Center(child: Text("MODEL"))
  },
  {
    'title': "Evaluate",
    "icon": Icons.leaderboard,
    "widget": Center(child: Text("EVALUATE"))
  },
  {'title': "Log", "icon": Icons.code, "widget": LogTab()},
];

class RattleHomePage extends StatefulWidget {
  const RattleHomePage({Key? key}) : super(key: key);

  @override
  _RattleHomePageState createState() => _RattleHomePageState();
}

class _RattleHomePageState extends State<RattleHomePage>
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
    var process;
    String cmd = "";

    return Scaffold(
      appBar: AppBar(
        // The left side menu item. May not be required.

        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),

        // The title aligned to the left.

        title: const Text("Rattle the Next Generation Data Scientist"),

        // Deploy the buttons aligned to the top right for actions.

        actions: [
          // INFO

          IconButton(
            onPressed: () {
              print(_tabs[_tabController.index]['title']);
              print(_tabs[_tabController.index]['widget']);
            },
            icon: Icon(Icons.info),
            tooltip: "Information.",
          ),

          // RUN

          IconButton(
            icon: const Icon(Icons.directions_run),
            onPressed: () {
              if (_tabs[_tabController.index]['title'] == "Data") {
                print("LOADING THE DATASET AS THE DATA TAB IS ACTIVE");

                loadDataset();
              } else {
                print("RUN NOT YET IMPLEMENTED AS IT IS NOT ON THE DATA TAB");
              }
            },
            tooltip: "Run the configured tab.",
          ),
          IconButton(
            icon: const Icon(Icons.open_in_new),
            onPressed: () async {
              print("KILL ALL R");
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
              print("SOURCE AUS WEATHER DATASET");
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
            tooltip: "Load weather.csv, summarise and save plot to file.",
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
            onPressed: () {},
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
      bottomNavigationBar: Container(
        height: 40,

        // 20230822 gjw I don't think I need padding any more on moving to the
        // Markdown() from Text(). Keep it for now in case I revert to Text().

        child: Padding(
          padding: EdgeInsets.only(left: 0),
          child: Markdown(
            data: 'Welcome to **RattleNG**. To begin, pick a file ' +
                '(e.g., CSV) containing your dataset, then click the ' +
                '🏃 Run button.',
            styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
          ),
        ),
      ),
    );
  }
}
