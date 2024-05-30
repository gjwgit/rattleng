/// The main tabs-based page interface.
///
/// Time-stamp: <Sunday 2024-05-19 14:08:09 +1000 Graham Williams>
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
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

// NOTE 20240516 gjw remove this after adding the Abuot dialog otherwise getting
// compile errors. What was the purpose of this?
//
//import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:rattle/constants/app.dart';
import 'package:rattle/features/dataset/tab.dart';
import 'package:rattle/features/debug/tab.dart';
import 'package:rattle/features/model/tab.dart';
import 'package:rattle/features/script/tab.dart';
import 'package:rattle/provider/path.dart';
import 'package:rattle/provider/stdout.dart';
import 'package:rattle/provider/target.dart';
import 'package:rattle/provider/vars.dart';
import 'package:rattle/r/console.dart';
import 'package:rattle/r/extract_vars.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/widgets/status_bar.dart';

part 'tabs.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  var _appVersion = 'Unknown';
  var _appName = 'Unknown';

  @override
  void initState() {
    super.initState();
    deleteFileIfExists();
    _tabController = TabController(length: tabs.length, vsync: this);
    _loadAppInfo();

    // Add a listener to the TabController to perform an action when we leave
    // the tab

    _tabController.addListener(() {
      // Check if we are leaving the tab, not entering it

      if (!_tabController.indexIsChanging) {
        if (_tabController.previousIndex == 0) {
          String path = ref.read(pathProvider);
          if (path.isNotEmpty) {
            // On leaving the DATASET tab we set the variables and run the data
            // template if there is a dataset loaded, as indicated by the path
            // having a value.

            List<String> vars = rExtractVars(ref.read(stdoutProvider));

            ref.read(varsProvider.notifier).state = vars;
            ref.read(targetProvider.notifier).state = vars.last;
            rSource(ref, "dataset_template");
          }
        }

        // You can also perform other actions here, such as showing a snackbar,
        // calling a function, etc.
      }
    });
  }

  Future<void> deleteFileIfExists() async {
    File fileToDelete = File(wordcloudImagePath);
    if (await fileToDelete.exists()) {
      await fileToDelete.delete();
      debugPrint('File $wordcloudImagePath deleted');
    }
  }

  Future<void> _loadAppInfo() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version; // Set app version from package info
      _appName = packageInfo.packageName; // Set app version from package info
    });
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
        // The title aligned to the left.

        title: const Text(appTitle),

        // Deploy the buttons aligned to the top right for actions.

        actions: [
          // NOTE 20240516 gjw Remove the Run button - no longer a part of the
          // app.

          // RUN

          // IconButton(
          //   key: const Key("run_button"),
          //   icon: const Icon(
          //     Icons.directions_run,
          //     color: Colors.grey,
          //   ),
          //   onPressed: () {
          //     debugPrint("RUN PRESSED NO ACTION AT THIS TIME");
          //     // KEEP OPEN FOR NOW FOR THE MODEL TAB.
          //     processTab(tabs[_tabController.index]['title']);
          //   },
          //   tooltip:
          //       "NO LONGER ACTIVE AT LEAST FOR NOW. WAS Run the current tab.",
          // ),

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

          // IconButton(
          //   icon: const Icon(
          //     Icons.download,
          //     color: Colors.grey,
          //   ),
          //   onPressed: () {
          //     debugPrint("LOAD PRESSED NO ACTION YET");
          //   },
          //   tooltip: "TODO: Load an existing project from file.",
          // ),

          // SAVE PROJECT

          // IconButton(
          //   icon: const Icon(
          //     Icons.upload,
          //     color: Colors.grey,
          //   ),
          //   onPressed: () {
          //     debugPrint("SAVE PRESSED NO ACTION YET");
          //   },
          //   tooltip: "TODO: Save the current project to file.",
          // ),

          // EXPORT - A tab specific export.
          //
          // On Model -> Wordcloud -> Image, then save the image to file.

          IconButton(
            icon: const Icon(
              Icons.save,
              color: Colors.grey,
            ),
            onPressed: () {
              debugPrint("SAVE PRESSED NO ACTION YET");
            },
            tooltip: "TODO: Save the current view to file.",
          ),

          // INFO

          IconButton(
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationName:
                    '${_appName[0].toUpperCase()}${_appName.substring(1)}',
                applicationVersion: _appVersion,
                children: [
                  const SelectableText('RattleNG is a modern rewrite of the '
                      'very popular Rattle Data Mining and Data Science tool.\n\n'
                      'Authors: Graham Williams, Yixiang Yin.'),
                ],
              );
            },
            icon: const Icon(
              Icons.info,
              color: Colors.blue,
            ),
          ),
        ],
      ),

      // Build the tab bar from the list of tabs, noting the tab title and
      // icon. We rotate the tab bar for placement on the left edge.

      body: Row(
        children: [
          RotatedBox(
            quarterTurns: 1,
            child: TabBar(
              controller: _tabController,
              //indicatorColor: Colors.yellow,
              //labelColor: Colors.yellow,
              unselectedLabelColor: Colors.grey,
              // dividerColor: Colors.green,
              //tabAlignment: TabAlignment.fill,
              isScrollable: false,
              tabs: tabs.map((tab) {
                // Rotate the tabs back the correct direction.

                return RotatedBox(
                  quarterTurns: -1,

                  // Wrap the tabs within a container so all have the same
                  // width, rotated, and the highloght is the same for each one
                  // irrespective of the text width.

                  child: SizedBox(
                    width: 100.0,
                    child: Tab(
                      icon: Icon(tab['icon']),
                      child: Text(
                        tab['title'],

                        // Reduce the font size to not overflow the widget.

                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),


          // Associate the Widgets with each of the bodies.

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: tabs.map((tab) {
                return tab['widget'] as Widget;
              }).toList(),
            ),
          ),
        ],
      ),

      // ignore: sized_box_for_whitespace
      bottomNavigationBar: const StatusBar(),
    );
  }
}
