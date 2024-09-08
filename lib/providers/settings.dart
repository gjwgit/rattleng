import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define a provider for managing settings
class SettingsNotifier extends StateNotifier<String> {
  SettingsNotifier() : super('theme_rattle'); // Default value

  void setGraphicTheme(String newTheme) {
    state = newTheme;
  }
}

// The provider we will use in the app
final settingsGraphicThemeProvider =
    StateNotifierProvider<SettingsNotifier, String>((ref) {
  return SettingsNotifier();
});
