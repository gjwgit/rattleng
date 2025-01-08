import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rattle/providers/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rattle/providers/session_control.dart';
import 'package:rattle/settings/utils/save_image_viewer_app.dart';

/// Save ask on exit setting
Future<void> saveAskOnExit(bool value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('askOnExit', value);
}

/// Reset session control settings
void resetSessionControl(WidgetRef ref) {
  ref.invalidate(askOnExitProvider);
  saveAskOnExit(true);

  final defaultApp = Platform.isWindows ? 'start' : 'open';
  ref.read(imageViewerSettingProvider.notifier).state = defaultApp;
  saveImageViewerApp(defaultApp);
}
