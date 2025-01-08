import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveImageViewerApp(String value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('imageViewerApp', value);
}
