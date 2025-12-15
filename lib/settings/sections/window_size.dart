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

  /// Load settings from providers and update text controllers
  void _loadSettings() {
    final savedWidth = ref.read(windowWidthProvider);
    final savedHeight = ref.read(windowHeightProvider);

    _widthController.text = savedWidth.toStringAsFixed(0);
    _heightController.text = savedHeight.toStringAsFixed(0);
  }

  /// Save window size settings to shared preferences
  Future<void> _saveWindowSizeSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final width = double.tryParse(_widthController.text);
    final height = double.tryParse(_heightController.text);

    if (width != null && width > 0) {
      ref.read(windowWidthProvider.notifier).state = width;
      await prefs.setDouble('windowWidth', width);
    }

    if (height != null && height > 0) {
      ref.read(windowHeightProvider.notifier).state = height;
      await prefs.setDouble('windowHeight', height);
    }

    // Save remember window size setting
    final rememberSize = ref.read(rememberWindowSizeProvider);
    await prefs.setBool('rememberWindowSize', rememberSize);
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
    ref.read(windowWidthProvider.notifier).state = defaultWindowWidth;
    ref.read(windowHeightProvider.notifier).state = defaultWindowHeight;
    ref.read(rememberWindowSizeProvider.notifier).state = true;

    _widthController.text = defaultWindowWidth.toStringAsFixed(0);
    _heightController.text = defaultWindowHeight.toStringAsFixed(0);

    await windowManager.setSize(Size(defaultWindowWidth, defaultWindowHeight));

    _saveWindowSizeSettings();
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
    final savedWidth = ref.watch(windowWidthProvider);
    final savedHeight = ref.watch(windowHeightProvider);

    // Keep controllers in sync with providers
    if (_widthController.text != savedWidth.toStringAsFixed(0)) {
      _widthController.text = savedWidth.toStringAsFixed(0);
    }
    if (_heightController.text != savedHeight.toStringAsFixed(0)) {
      _heightController.text = savedHeight.toStringAsFixed(0);
    }

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
            style: const TextStyle(fontSize: 16,),
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
                      ref.read(rememberWindowSizeProvider.notifier).state = value;
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

