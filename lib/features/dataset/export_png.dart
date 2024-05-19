import 'package:file_picker/file_picker.dart';

Future<String?> selectFile() async {
  // Use the [FilePicker] to select a file asynchronously so as not to block the
  // main UI thread.

  String? result = await FilePicker.platform.saveFile(
    dialogTitle: "pick a location to save the file",
    fileName: "wordcloud.png",
  );
  return result;
}
