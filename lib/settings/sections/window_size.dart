/// Window size section.
//
// Time-stamp: "Sunday 2025-12-14 17:21:00 +1100 Graham Williams"
//
/// Copyright (C) 2024, Togaware Pty Ltd
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://opensource.org/license/gpl-3-0
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
// this program.  If not, see <https://opensource.org/license/gpl-3-0>.
///
/// Authors: Aditya Arora

library;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

import 'package:rattle/constants/spacing.dart';
import 'package:rattle/providers/settings.dart';
import 'package:rattle/utils/is_desktop.dart';
import 'package:rattle/utils/window_size.dart';

class WindowSize extends ConsumerStatefulWidget {
  const WindowSize({super.key});

  @override
  ConsumerState<WindowSize> createState() => _WindowSizeState();
}

class _WindowSizeState extends ConsumerState<WindowSize> with WindowListener {
  late final TextEditingController _widthController;
  late final TextEditingController _heightController;
  double? _currentWidth;
  double? _currentHeight;

  @override
  void initState() {
    super.initState();
    _widthController = TextEditingController();
    _heightController = TextEditingController();
    windowManager.addListener(this);
    _loadCurrentWindowSize();
    _loadSettings();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    _widthController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  /// Load the current window size from the window manager
  Future<void> _loadCurrentWindowSize() async {
    if (isDesktop) {
      try {
        final size = await windowManager.getSize();
        setState(() {
          _currentWidth = size.width;
          _currentHeight = size.height;
        });
      } catch (e) {
        debugPrint('Error loading current window size: $e');
      }
    }
  }

  /// Fill the text fields from the saved window size.
  ///
  /// Read from the preferences rather than from the providers, which the
  /// enclosing SETTINGS dialog loads asynchronously and so may not have
  /// populated by the time this section is built. (gjw 20260817)

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final Size size = await windowManager.getSize();

    if (!mounted) return;

    _widthController.text =
        (prefs.getDouble(windowWidthPref) ?? size.width).toStringAsFixed(0);
    _heightController.text =
        (prefs.getDouble(windowHeightPref) ?? size.height).toStringAsFixed(0);
  }

  /// Save window size settings to shared preferences
  Future<void> _saveWindowSizeSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final width = double.tryParse(_widthController.text);
    final height = double.tryParse(_heightController.text);

    if (width != null && width > 0) {
      await prefs.setDouble(windowWidthPref, width);
    }

    if (height != null && height > 0) {
      await prefs.setDouble(windowHeightPref, height);
    }

    await prefs.setBool(
      rememberWindowSizePref,
      ref.read(rememberWindowSizeProvider),
    );
  }

  /// Apply the window size from the text fields to the actual window
  Future<void> _applyWindowSize() async {
    final width = double.tryParse(_widthController.text);
    final height = double.tryParse(_heightController.text);

    if (width != null && width > 0 && height != null && height > 0) {
      try {
        await windowManager.setSize(Size(width, height));
        await _loadCurrentWindowSize();
        await _saveWindowSizeSettings();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error applying window size: $e'),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }

  /// Reset window size settings to defaults
  Future<void> _resetWindowSize() async {
    ref.read(rememberWindowSizeProvider.notifier).state = true;

    _widthController.text = defaultWindowWidth.toStringAsFixed(0);
    _heightController.text = defaultWindowHeight.toStringAsFixed(0);

    await windowManager
        .setSize(const Size(defaultWindowWidth, defaultWindowHeight));

    await _saveWindowSizeSettings();
  }

  @override
  void onWindowResize() async {
    if (!mounted) return;
    try {
      final size = await windowManager.getSize();
      setState(() {
        _currentWidth = size.width;
        _currentHeight = size.height;
      });
    } catch (e) {
      debugPrint('Error updating window size on resize: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final rememberSize = ref.watch(rememberWindowSizeProvider);

    // 20260817 gjw The text fields are NOT written to from here. They used to
    // be kept in step with the providers on every build, which meant that a
    // rebuild part way through typing a width, and resizing the window rebuilds
    // this on every frame of the drag, replaced what was being typed with the
    // value that was there before. The fields are the user's to fill in, and
    // are written to only by Reset and when the section is first built.

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Window Size',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            configRowGap,
            MarkdownTooltip(
              message: '''
              
              **Reset Window Size:** Tap here to reset the window size
              settings to the default values (${defaultWindowWidth.toInt()}x${defaultWindowHeight.toInt()}).
              
              ''',
              child: ElevatedButton(
                onPressed: _resetWindowSize,
                child: const Text('Reset'),
              ),
            ),
          ],
        ),
        configRowGap,
        // Display current window size
        if (_currentWidth != null && _currentHeight != null)
          Text(
            'Current window size: ${_currentWidth!.toInt()} × ${_currentHeight!.toInt()}',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        configRowGap,
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            MarkdownTooltip(
              message: '''
              
              **Window Width:** Set the desired window width in pixels.
              This value will be used when the app starts up.
              
              ''',
              child: SizedBox(
                width: 150,
                child: TextField(
                  controller: _widthController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Width (pixels)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            configRowGap,
            MarkdownTooltip(
              message: '''
              
              **Window Height:** Set the desired window height in pixels.
              This value will be used when the app starts up.
              
              ''',
              child: SizedBox(
                width: 150,
                child: TextField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Height (pixels)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            configRowGap,
            ElevatedButton(
              onPressed: _applyWindowSize,
              child: const Text('Apply'),
            ),
          ],
        ),
        configRowGap,
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            MarkdownTooltip(
              message: '''
              
              **Remember Window Size on Exit:** When enabled, the current
              window size will be automatically saved when you exit the app,
              overriding any manually set values. When disabled, the window
              size will only use the manually set values and will not be
              updated on exit.
              
              ''',
              child: Row(
                children: [
                  const Text(
                    'Remember window size on exit',
                    style: TextStyle(fontSize: 16),
                  ),
                  configRowGap,
                  Switch(
                    value: rememberSize,
                    onChanged: (value) {
                      ref.read(rememberWindowSizeProvider.notifier).state =
                          value;
                      _saveWindowSizeSettings();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        settingsGroupGap,
        const Divider(),
      ],
    );
  }
}
