import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';
import 'package:rattle/providers/settings.dart';
import 'package:rattle/settings/utils/save_image_viewer_app.dart';

class ImageViewerTextField extends ConsumerWidget {
  const ImageViewerTextField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _buildImageViewerTextField(context, ref);
  }

  Widget _buildImageViewerTextField(BuildContext context, WidgetRef ref) {
    final imageViewerApp = ref.watch(imageViewerSettingProvider);

    return MarkdownTooltip(
      message: '''

      **Image Viewer Application Setting:** This setting determines the default
      command to open image files. The default is "open" on Linux/MacOS and "start"
      on Windows. You can customise it to match your preferred image viewer.

      ''',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            'Image Viewer',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 150,
            ),
            child: TextField(
              controller: TextEditingController(text: imageViewerApp)
                ..selection =
                    TextSelection.collapsed(offset: imageViewerApp.length),
              onChanged: (value) {
                ref.read(imageViewerSettingProvider.notifier).state = value;
                saveImageViewerApp(value);
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter image viewer command',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
