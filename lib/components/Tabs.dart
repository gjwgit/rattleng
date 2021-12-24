import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';

// https://blog.logrocket.com/flutter-tabbar-a-complete-tutorial-with-examples/

class Tabs extends StatelessWidget {
  const Tabs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var process, cmd;
    return DefaultTabController(
      initialIndex: 0,
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {},
          ),
          title: Text("Rattle for the Data Scientist"),
          actions: [
            IconButton(
              icon: const Icon(Icons.directions_run),
              onPressed: () async {

                process = await Process.start('killall', ["R"]);
                process = await Process.start('R', ["--no-save"]);
                process.stdout
                  .transform(utf8.decoder)
                  .forEach(print);
                process.stderr
                  .transform(utf8.decoder)
                  .forEach(print);

                cmd = 'library(tidyverse)';
                process.stdin.writeln(cmd);

              },
              tooltip: "Once a tab is configured click here to have it run.",
            ),
            IconButton(
              icon: const Icon(Icons.open_in_new),
              onPressed: () {
                cmd = "getwd()";
                process.stdin.writeln(cmd);
                cmd = 'ds <- read_csv("weather.csv")';
                process.stdin.writeln(cmd);
                cmd = 'summary(ds)';
                process.stdin.writeln(cmd);
                cmd = 'ds %>% ggplot(aes(x=WindDir3pm)) + geom_bar()';
                process.stdin.writeln(cmd);
                cmd = 'ggsave("myplot.pdf", width=11, height=7)';
                process.stdin.writeln(cmd);
              },
              tooltip: "Start a new project.",
            ),
            IconButton(
              icon: const Icon(Icons.open_in_browser_outlined),
              onPressed: () {
                Process.run("xdg-open", ["myplot.pdf"]);
              },
              tooltip: "Load an existing project from file.",
            ),
            IconButton(
              icon: const Icon(Icons.save_alt_outlined),
              onPressed: () {
              },
             tooltip: "Save the current project to file.",
            ),
            IconButton(
              icon: const Icon(Icons.exit_to_app_outlined),
              onPressed: () {
              },
              tooltip: "Exit the application.",
            ),
            PopupMenuButton<Text>(
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: Text("About Rattle"),
                  ),
                  PopupMenuItem(
                    child: Text("Browse Rattle Survival Guide"),
                  ),
                  PopupMenuItem(
                    child: Text("Browse Togaware"),
                  ),
                ];
              },
            )
          ],
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.input),
                text: "data",
              ),
              Tab(
                icon: Icon(Icons.insights),
                text: "explore",
              ),
              Tab(
                icon: Icon(Icons.task),
                text: "test",
              ),
              Tab(
                icon: Icon(Icons.transform),
                text: "transform",
              ),
              Tab(
                icon: Icon(Icons.model_training),
                text: "model",
              ),
              Tab(
                icon: Icon(Icons.leaderboard),
                text: "evaluate",
              ),
              Tab(
                icon: Icon(Icons.code),
                text: "log",
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            Center(
              child: Text("DATA"),
            ),
            Center(
              child: Text("EXPLORE"),
            ),
            Center(
              child: Text("TEST"),
            ),
            Center(
              child: Text("TRANSFORM"),
            ),
            Center(
              child: Text("MODEL"),
            ),
            Center(
              child: Text("EVALUATE"),
            ),
            Center(
              child: Text("LOG"),
            ),
          ],
        ),
      ),
    );
  }
}
