/// Model tab for home page.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
//
// Time-stamp: <Friday 2023-11-03 05:45:47 +1100 Graham Williams>
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

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rattle/features/dataset/tab.dart';
import 'package:rattle/features/model/build_button.dart';
import 'package:rattle/features/model/forest_tab.dart';
import 'package:rattle/features/model/save_wordcloud_png.dart';
import 'package:rattle/features/model/tree_tab.dart';
import 'package:rattle/provider/model.dart';
import 'package:rattle/provider/stdout.dart';
import 'package:rattle/provider/wordcloud/checkbox.dart';

import 'package:rattle/provider/wordcloud/maxword.dart';
import 'package:rattle/provider/wordcloud/minfreq.dart';
import 'package:rattle/provider/wordcloud/punctuation.dart';
import 'package:rattle/provider/wordcloud/stem.dart';
import 'package:rattle/provider/wordcloud/stopword.dart';

final List<Map<String, dynamic>> tabs = [
  {
    'title': "Cluster",
    "widget": const Column(
      children: <Widget>[
        SizedBox(height: 50),
        Text("NOT YET IMPLEMENTED"),
      ],
    ),
  },
  {
    'title': "Associate",
    "widget": const Column(
      children: <Widget>[
        SizedBox(height: 50),
        Text("NOT YET IMPLEMENTED"),
      ],
    ),
  },
  {
    'title': "Tree",
    "widget": const TreeTab(),
  },
  {
    'title': "Forest",
    "widget": const ForestTab(),
  },
  {
    'title': "Boost",
    "widget": const Column(
      children: <Widget>[
        SizedBox(height: 50),
        Text("NOT YET IMPLEMENTED"),
      ],
    ),
  },
  {
    'title': "Wordcloud",
    // TODO put them in a class wordcloudtab
    "widget": SingleChildScrollView(
        child: Column(
      children: [
        ConfigBar(),
        WordCloudWindow(),
        ModelBuildButton(),
      ],
    )),
  },
  {
    'title': "SVM",
    "widget": const Column(
      children: <Widget>[
        SizedBox(height: 50),
        Text("NOT YET IMPLEMENTED"),
      ],
    ),
  },
  {
    'title': "Linear",
    "widget": const Column(
      children: <Widget>[
        SizedBox(height: 50),
        Text("NOT YET IMPLEMENTED"),
      ],
    ),
  },
  {
    'title': "Neural",
    "widget": const Column(
      children: <Widget>[
        SizedBox(height: 50),
        Text("NOT YET IMPLEMENTED"),
      ],
    ),
  },
];

// TODO 20230916 gjw DOES THIS NEED TO BE STATEFUL?

var systemTempDir = Directory.systemTemp;

String word_cloud_image_path = "${systemTempDir.path}/wordcloud.png";

class ModelTab extends ConsumerStatefulWidget {
  const ModelTab({Key? key}) : super(key: key);

  @override
  ConsumerState<ModelTab> createState() => _ModelTabState();
}

class _ModelTabState extends ConsumerState<ModelTab>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);

    _tabController.addListener(() {
      ref.read(modelProvider.notifier).state = tabs[_tabController.index]["title"];
      debugPrint("Selected tab: ${_tabController.index}");
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
    debugPrint("modeltab rebuild.");
    // TODO missing build button; place it on the bottom right as a floating button yyx
    
    return Column(
      children: [
        TabBar(
          unselectedLabelColor: Colors.grey,
          controller: _tabController,
          tabs: tabs.map((tab) {
            return Tab(
              text: tab['title'],
            );
          }).toList(),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: tabs.map((tab) {
              return tab['widget'] as Widget;
            }).toList(),
          ),
        ),
      ],
    );
  }

  // disable the automatic rebuild everytime we switch to the model tab.
  @override
  bool get wantKeepAlive => true;
}

class WordCloudWindow extends ConsumerStatefulWidget {
  const WordCloudWindow({Key? key}) : super(key: key);
  @override
  ConsumerState<WordCloudWindow> createState() => _WordCloudWindowState();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint("wordcloud window build");
    debugPrint("path: ${word_cloud_image_path}");
    // reload the wordcloud png
    imageCache.clear();
    imageCache.clearLiveImages();
    String rebuild = ref.watch(wordcloudBuildProvider);
    debugPrint("received rebuild on $rebuild");
    // debugPrint("build wordcloud window.");
    var word_cloud_file = File(word_cloud_image_path);
    bool pngBuild = word_cloud_file.existsSync();
    if (!pngBuild) {
      debugPrint("No model has been built.");
      return Column(
        children: [
          SizedBox(height: 50),
          Text("No model has been built"),
        ],
      );
    }

    if (pngBuild) {
      debugPrint("model has been built.");

      return Column(
        children: [
          Image.file(File(word_cloud_image_path)),
          SaveWordCloudButton(
            wordCloudImagePath: word_cloud_image_path,
          ),
        ],
      );
    }
    return const Text("bug");
  }
}
class _WordCloudWindowState extends ConsumerState<WordCloudWindow> {
  @override
  Widget build(BuildContext context) {
    debugPrint("wordcloud window build");
    debugPrint("path: ${word_cloud_image_path}");
    // reload the wordcloud png
    imageCache.clear();
    imageCache.clearLiveImages();
    String rebuild = ref.watch(wordcloudBuildProvider);
    debugPrint("received rebuild on $rebuild");
    // debugPrint("build wordcloud window.");
    var word_cloud_file = File(word_cloud_image_path);
    bool pngBuild = word_cloud_file.existsSync();
    if (!pngBuild) {
      debugPrint("No model has been built.");
      return const Column(
        children: [
          SizedBox(height: 50),
          Text("No model has been built"),
        ],
      );
    }

    if (pngBuild) {
      debugPrint("model has been built.");
      // reload the image (https://nambiarakhilraj01.medium.com/what-to-do-if-fileimage-imagepath-does-not-update-on-build-in-flutter-622ad5ac8bca
      var bytes = word_cloud_file.readAsBytesSync();
      Image image = Image.memory(bytes);
      return Column(
        children: [
          Text("the last rebuild time is $rebuild"),
          image,
          SaveWordCloudButton(
            wordCloudImagePath: word_cloud_image_path,
          ),
        ],
      );
    }
    return const Text("bug");
  } 
}

class ConfigBar extends ConsumerStatefulWidget {
  const ConfigBar({super.key});

  @override
  ConsumerState<ConfigBar> createState() => _ConfigBarState();
}

class _ConfigBarState extends ConsumerState<ConfigBar> {
  final maxWordTextController = TextEditingController();
  final minFreqTextController = TextEditingController();
  @override
  void initState() {
    super.initState();
    maxWordTextController.addListener(_updateMaxWordProvider);
    minFreqTextController.addListener(_updateMinFreqProvider);
  }

  @override
  void dispose() {
    maxWordTextController.dispose();
    minFreqTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            // checkbox for random color
            Row(
              children: [
                Checkbox(
                  value: ref.watch(checkboxProvider),
                  onChanged: (bool? v) => {
                    ref.read(checkboxProvider.notifier).state = v!,
                  },
                ),
                const Text("random order"),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: ref.watch(stemProvider),
                  onChanged: (bool? v) => {
                    ref.read(stemProvider.notifier).state = v!,
                  },
                ),
                const Text("stem"),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: ref.watch(stopwordProvider),
                  onChanged: (bool? v) => {
                    ref.read(stopwordProvider.notifier).state = v!,
                  },
                ),
                const Text("remove stopword"),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: ref.watch(punctuationProvider),
                  onChanged: (bool? v) => {
                    ref.read(punctuationProvider.notifier).state = v!,
                  },
                ),
                const Text("remove punctuation"),
              ],
            ),
            const SizedBox(
              width: 5,
            ),
          ],
        ),
        Row(
          children: [
            // max word text field
            SizedBox(
              width: 150.0,
              child: TextField(
                controller: maxWordTextController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: "max word"),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            SizedBox(
              width: 150.0,
              child: TextField(
                controller: minFreqTextController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: "min freq"),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _updateMaxWordProvider() {
    debugPrint("max word text changed to ${maxWordTextController.text}");
    ref.read(maxWordProvider.notifier).state = maxWordTextController.text;
  }

  void _updateMinFreqProvider() {
    debugPrint("min freq text changed to ${minFreqTextController.text}");
    ref.read(minFreqProvider.notifier).state = minFreqTextController.text;
  }
}

// class ConfigBar extends ConsumerWidget {
//   const ConfigBar({super.key});
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Row(
//       children: [
//         // checkbox for random color
//         Row(
//           children: [
//             Checkbox(
//               value: ref.watch(checkboxProvider),
//               onChanged: (bool? v) => {
//                 ref.read(checkboxProvider.notifier).state = v!,
//               },
//             ),
//             Text("random order"),
//           ],
//         ),
//         const SizedBox(width: 5,),
//         // max word text field
//         SizedBox(
//           width: 100.0,
//           child: TextField(
//             decoration: InputDecoration(
//                 border: OutlineInputBorder(), hintText: "max word"),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class MaxWordTextField extends ConsumerStatefulWidget {
//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() {
//     // TODO: implement createState
//     throw UnimplementedError();
//   }

// }
