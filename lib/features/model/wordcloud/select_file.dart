import 'package:file_picker/file_picker.dart';

Future<String?> selectFile() async {
  // Use the [FilePicker] to select a file asynchronously so as not to block the
  // main UI thread.

  String? result = await FilePicker.platform.saveFile(
    dialogTitle: "pick a location to save the file",
    // TODO 20240604 gjw THE DEFAULT FILE NAME DOES NOT APPEAR IN THE DIALOG ON
    // LINUX. COULD BE A PACKAGE BUG? SHOULD REPORT IF SO.
    fileName: "wordcloud.png",
  );
  return result;
}
