// /// The model tabs-based page interface.
// part of 'tab.dart';

// /// Define a mapping for the tabs in the GUI on to title:icon:widget.

// final List<Map<String, dynamic>> tabs = [
//   {
//     'title': "Dataset",
//     "icon": Icons.input,
//     "widget": const DatasetTab(),
//   },
//   {
//     'title': "Explore",
//     "icon": Icons.insights,
//     "widget": Center(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Image.asset("assets/images/myplot.png"),
//       ),
//     ),
//   },
//   {
//     'title': "Test",
//     "icon": Icons.task,
//     "widget": const Center(child: Text("TEST")),
//   },
//   {
//     'title': "Transform",
//     "icon": Icons.transform,
//     "widget": const Center(child: Text("TRANSFORM")),
//   },
//   {
//     'title': "Model",
//     "icon": Icons.model_training,
//     // "widget": const Center(child: Text("MODEL")),
//     "widget": const ModelTab(),
//   },
//   {
//     'title': "Evaluate",
//     "icon": Icons.leaderboard,
//     "widget": const Center(child: Text("EVALUATE")),
//   },
//   {
//     'title': "Console",
//     "icon": Icons.terminal,
// //    "widget": TerminalView(terminal),
//     "widget": const RConsole(),
//   },
//   {
//     'title': "Script",
//     "icon": Icons.code,
//     "widget": const ScriptTab(),
//   },
//   {
//     'title': "Debug",
//     "icon": Icons.work,
//     // "widget": const Center(child: Text("DEBUG")),
//     "widget": const DebugTab(),
//   },
// ];
