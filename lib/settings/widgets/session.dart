import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';
import 'package:rattle/constants/spacing.dart';
import 'package:rattle/providers/session_control.dart';
import 'package:rattle/providers/settings.dart';
import 'package:rattle/settings/utils/session_settings.dart';
import 'package:rattle/settings/widgets/image_viewer_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Session extends ConsumerWidget {
  const Session({super.key});

  Future<void> _saveAskOnExit(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('askOnExit', value);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final askOnExit = ref.watch(askOnExitProvider);

    return Column(
      children: [
        Row(
          children: [
            const Text(
              'Session',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            configRowGap,
            MarkdownTooltip(
              message: '''

              **Reset Session Control:** Tap here to reset to enable a confirmation
              popup when exiting the application.


              **Reset Image Viewer App:** Tap here to reset the Image Viewer App setting
              to the platform's default ("open" on Linux/MacOS, "start" on Windows).

              ''',
              child: ElevatedButton(
                onPressed: () => resetSessionControl(ref),
                child: const Text('Reset'),
              ),
            ),
          ],
        ),
        configRowGap,
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            MarkdownTooltip(
              message: '''

              **Session Control:** This setting determines whether a confirmation popup
              appears when the user tries to quit the application.

              - **ON**: A popup will appear asking the user to confirm quitting.

              - **OFF**: The application will exit immediately without a confirmation popup.

              The default setting is **ON**.

              ''',
              child: Row(
                children: [
                  const Text(
                    'Ask before exit',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  configRowGap,
                  Switch(
                    value: askOnExit,
                    onChanged: (value) {
                      ref.read(askOnExitProvider.notifier).state = value;
                      _saveAskOnExit(value);
                    },
                  ),
                ],
              ),
            ),
            configRowGap,
            const ImageViewerTextField(),
          ],
        ),
        settingsGroupGap,
        const Divider(),
      ],
    );
  }
}
