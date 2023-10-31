/// The main tabs-based page interface.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Monday 2023-10-30 06:32:00 +1100 Graham Williams>
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

/// Experimenting with the use of part to break out the definition of the tabs
/// into its own file. This is a textual split and is as if this file was
/// actaully embedded in the file it is a part of. Thus this file does not have
/// it's own imports. The use of [part] is discouraged for the original old idea
/// of it, but seems like a useful feetaure in this case, keeping my files
/// smaller, and compartmentalising the tab variable, though not having it
/// immediately available within the code that is using it.

part of 'home_page.dart';

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
  {
    'title': "Debug",
    "icon": Icons.work,
    // "widget": const Center(child: Text("DEBUG")),
    "widget": const DebugTab(),
  },
];
