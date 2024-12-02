/// The main tabs-based interface for the Rattle app.
///
/// Time-stamp: <Sunday 2024-11-24 20:09:35 +1100 Graham Williams>
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

library;

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:catppuccin_flutter/catppuccin_flutter.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';

import 'package:rattle/constants/app.dart';
import 'package:rattle/constants/spacing.dart';
import 'package:rattle/constants/wordcloud.dart';
import 'package:rattle/features/evaluate/panel.dart';
import 'package:rattle/providers/dataset_loaded.dart';
import 'package:rattle/providers/datatype.dart';
import 'package:rattle/r/console.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/features/dataset/panel.dart';
import 'package:rattle/tabs/debug/tab.dart';
import 'package:rattle/tabs/explore.dart';
import 'package:rattle/tabs/model.dart';
import 'package:rattle/tabs/script/tab.dart';
import 'package:rattle/tabs/transform.dart';
import 'package:rattle/utils/reset.dart';
import 'package:rattle/utils/show_dataset_alert_dialog.dart';
import 'package:rattle/utils/show_ok.dart';
import 'package:rattle/utils/show_settings_dialog.dart';
import 'package:rattle/widgets/status_bar.dart';

// Define the [NavigationRail] tabs for the home page.

final List<Map<String, dynamic>> homeTabs = [
  {
    'title': 'Dataset',
    'icon': Icons.input,
  },
  {
    'title': 'Explore',
    'icon': Icons.insights,
  },
  {
    'title': 'Transform',
    'icon': Icons.transform,
  },
  {
    'title': 'Model',
    'icon': Icons.model_training,
  },
  {
    'title': 'Evaluate',
    'icon': Icons.leaderboard,
  },
  {
    'title': 'Console',
    'icon': Icons.terminal,
  },
  {
    'title': 'Script',
    'icon': Icons.code,
  },
  {
    'title': 'Debug',
    'icon': Icons.work,
  },
];

class RattleHome extends ConsumerStatefulWidget {
  const RattleHome({super.key});

  @override
  ConsumerState<RattleHome> createState() => RattleHomeState();
}

class RattleHomeState extends ConsumerState<RattleHome>
    with SingleTickerProviderStateMixin {
  // We use a [tabController] to manager what scripts are run on moving from the
  // DATASET feature. The [tabController] keeps track of the selected index for
  // the NavigationRail.

  late TabController _tabController;

  // We will populate the app name and version.

  var _appName = 'Unknown';
  var _appVersion = 'Unknown';
  final String _changelogUrl =
      'https://github.com/gjwgit/rattleng/blob/dev/CHANGELOG.md';

  // Helper function to cleanup any wordcloud leftover files.

  // TODO 20240613 gjw DO WE NEED THIS?

  Future<void> deleteFileIfExists() async {
    // clean up the files from previous use
    File fileToDelete = File(wordCloudImagePath);
    if (await fileToDelete.exists()) {
      await fileToDelete.delete();
      debugPrint('File $wordCloudImagePath deleted');
    }
    File tmpImageFile = File(tmpImagePath);
    if (await tmpImageFile.exists()) {
      await tmpImageFile.delete();
      debugPrint('File $tmpImagePath deleted');
    }
  }

  // Helper function to load the app name and version.

  Future<void> _loadAppInfo() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appName = packageInfo.packageName; // Set app version from package info
      _appVersion = packageInfo.version; // Set app version from package info
    });
  }

  void goToDatasetTab() {
    setState(() {
      _tabController.index = 0;
    });
  }

  late List<Widget> _tabWidgets;

  @override
  void initState() {
    super.initState();

    // TODO 20240613 gjw IS THIS REQUIRED?

    deleteFileIfExists();

    // Get the app name and version.

    _loadAppInfo();

    // Create the [tabController] to manage what happens on leaving/entering
    // tabs.

    _tabController = TabController(length: homeTabs.length, vsync: this);

    // Initialize the tab widgets once in order to use IndexedStack later.

    _tabWidgets = [
      const DatasetPanel(),
      const ExploreTabs(),
      const TransformTabs(),
      const ModelTabs(),
      const EvaluatePanel(),
      const RConsole(),
      const ScriptTab(),
      const DebugTab(),
    ];

    // Add a listener to the TabController to perform an action when we leave
    // the tab.

    _tabController.addListener(() {
      // Check if we are leaving the tab, not entering it.

      if (!_tabController.indexIsChanging) {
        // Index 0 is the DATABASE tab.
        // Index 2 is the TRANSFORM tab.
        if (_tabController.previousIndex == 0 ||
            _tabController.previousIndex == 2) {
          // 20241123 gjw For a table type dataset we want to run the
          // dataset_template script.

          if (ref.read(datatypeProvider) == 'table') {
            // 20241008 gjw On leaving the DATASET tab we run the data template
            // if there is a dataset loaded, as indicated by the path having a
            // value. We need to run the template here after we have loaded and
            // setup the variable roles. Trying to run the dataset template
            // before leaving the DATASET tab results TARGET in and RISK being
            // set to NULL.
            //
            // Note that variable roles are set up in
            // `features/dataset/display.dart` after the dataset is loaded and
            // we need to wait until the roles are set before we run the
            // template.
            //
            // 20241123 gjw Only perform a dataset template if the path is not a
            // text file.

            rSource(context, ref, ['dataset_template']);
          }
        }

        // You can also perform other actions here, such as showing a snackbar,
        // calling a function, etc.
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String about = '''${wordWrap('''

  RattleNG is a modern rewrite of the very popular Rattle Data Mining and Data
  Science tool. Visit the [Rattle Home Page](https://rattle.togaware.com) for
  details.

  ''')}

Author: Graham Williams

Contributions: Bob Muenchen, Tony Nolan, Mukund B Srinivas, Kevin Wang, Zheyuan
Xu, Yixiang Yin, Bo Zhang.

  ''';

  @override
  Widget build(BuildContext context) {
    Flavor flavor = catppuccin.latte;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: flavor.mantle,

        // The title aligned to the left.

        //title: const Text(appTitle),

        title: Row(
          children: [
            Image.asset(
              'assets/icons/icon.png',
              width: 40,
              height: 40,
            ),
            configWidgetGap,
            const Text(appTitle),
          ],
        ),

        // Deploy the buttons aligned to the top right for actions.

        actions: [
          // While the version number is reported in the About popup but for
          // screenshots, during development it is useful to have the version
          // visiable at all times, particularly for a screenshot, so place it
          // on the title bar for now.

          MarkdownTooltip(
            message: '''

            **Version:** *Rattle* is regularly updated to bring you the best
            experience for Data Science, AI and Machine Learning. The latest
            version is always available from the
            [Rattle](https://togaware.com/projects/rattle/) website. **Tap** on
            the **Version** text here in the title bar to visit the *CHANGELOG*
            in your browser and so see a list of all changes to Rattle. This
            will help decide whether you want to update now.

            ''',
            child: GestureDetector(
              onTap: () async {
                final Uri url = Uri.parse(_changelogUrl);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  debugPrint('Could not launch $_changelogUrl');
                }
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Text(
                  'Version $_appVersion',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 50),

          // Reset.

          MarkdownTooltip(
            message: '''

            **Reset:** Tap here to clear the current project and so start a new
            project with a new dataset. You will be prompted to confirm since
            you will lose all of the current pages and analyses.

            ''',
            child: IconButton(
              icon: const Icon(
                Icons.autorenew,
                color: Colors.blue,
              ),
              onPressed: () async {
                // TODO yyx 20240611 return focus to DATASET TAB and set the sub tabs to the first tabs (put it in reset)
                if (ref.read(datasetLoaded)) {
                  showDatasetAlertDialog(context, ref, false);
                } else {
                  await reset(context, ref);
                }
              },
            ),
          ),

          // 20240726 gjw Remove the global SAVE button for now in favour of the
          // local widget save buttons. It is probably a better concept to have
          // the save buttons associated with the individual widgets than trying
          // to find the current widget and calling a save() if it has one.

          // SAVE - Context specific.

          // IconButton(
          //   icon: const Icon(
          //     Icons.save,
          //     color: Colors.grey,
          //   ),
          //   onPressed: () {
          //     debugPrint('SAVE PRESSED NO ACTION YET');
          //   },
          //   tooltip: 'TODO: Save the current view to file.',
          // ),

          // Install R Packages

          MarkdownTooltip(
            message: '''

            **R Package Installation:** Tap here to load all required R pacakges
            now rather than when they are needed. It can be useful to do this
            before you load a dataset so as to ensure everything is ready. This
            can avoid some issues on startup. Rattle will check for any R
            packages that need to be installed and will install them. This could
            take some time, *upwards of 5 minutes,* for example. After starting
            this installation do check the **Console** tab for details and
            progress.

            ''',
            child: IconButton(
              icon: const Icon(
                Icons.download,
                color: Colors.blue,
              ),
              onPressed: () async {
                showOk(
                  context: context,
                  title: 'Install R Packages',
                  content: '''

                  Rattle is now checking each of the requisite **R Packages**
                  and if not available on your local installation it will be
                  downloaded and installed. This can take some time (**five
                  minutes** or more) depending on how many packages need to be
                  installed. Please check the **Console** tab to monitor
                  progress. Type *Ctrl-C* in the **Console** to abort.

                  ''',
                );
                await rSource(context, ref, ['packages']);
                // TODO 20241014 gjw HOW TO NAVIGATE TO THE CONSOLE TAB
              },
            ),
          ),

          // Settings.

          MarkdownTooltip(
            message: '''

            **Settings:** Tap here to update your default settings. At present we
            have just one setting: ggplot theme. The default theme is the simple
            and clean Rattle theme but there are many themes to choose
            from. Your settings will be saved for this session and you have the
            option to reset to the Rattle defaults.

            ''',
            child: IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.blue,
              ),
              onPressed: () async {
                showSettingsDialog(context);
              },
            ),
          ),

          // Info - about.

          MarkdownTooltip(
            message: '''

            **About:** Tap here to view information about the Rattle
            project. This include a list of those who have contributed to the
            latest version of the software, *Verison 6.* It also includes the
            extensive list of open-source packages that Rattle is built on and
            their licences.
            
            ''',
            child: IconButton(
              onPressed: () {
                showAboutDialog(
                  context: context,
                  applicationIcon: Image.asset(
                    'assets/icons/icon.png',
                    width: 80,
                    height: 80,
                  ),
                  applicationName:
                      '${_appName[0].toUpperCase()}${_appName.substring(1)}',
                  applicationVersion: 'Version $_appVersion',
                  applicationLegalese: '© 2006-2024 Togaware Pty Ltd\n',
                  children: [
                    MarkdownBody(
                      data: about,
                      selectable: true,
                      softLineBreak: true,
                      onTapLink: (text, href, about) {
                        final Uri url = Uri.parse(href ?? '');
                        launchUrl(url);
                      },
                    ),
                  ],
                );
              },
              icon: const Icon(
                Icons.info,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),

      // Build the tab bar from the list of homeTabs, noting the tab title and
      // icon. We rotate the tab bar for placement on the left edge.

      body: Row(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              // Constrain height to the height of the screen.
              // To place the NavigationRail on top of the Column.

              height: MediaQuery.of(context).size.height,
              child: NavigationRail(
                selectedIndex: _tabController.index,
                onDestinationSelected: (int index) {
                  setState(() {
                    _tabController.index = index;
                  });
                },
                labelType: NavigationRailLabelType.all,
                destinations: homeTabs.map((tab) {
                  return NavigationRailDestination(
                    icon: Icon(tab['icon']),
                    label: Text(
                      tab['title'],
                      style: const TextStyle(fontSize: 16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                  );
                }).toList(),
                selectedLabelTextStyle: const TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelTextStyle: TextStyle(color: Colors.grey[500]),
              ),
            ),
          ),
          const VerticalDivider(),
          Expanded(
            child: IndexedStack(
              index: _tabController.index,
              children: _tabWidgets,
            ),
          ),
        ],
      ),

      bottomNavigationBar: const StatusBar(),
    );
  }
}
