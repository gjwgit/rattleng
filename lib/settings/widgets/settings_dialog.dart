/// Settings dialog high-level widget.
//
// Time-stamp: <Monday 2025-01-06 15:20:25 +1100 Graham Williams>
//
/// Copyright (C) 2024, Togaware Pty Ltd
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
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
// this program.  If not, see <https://www.gnu.org/licenses/>.
///
/// Authors: Graham Williams, Kevin Wang

library;

import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rattle/settings/widgets/section_dataset_toggles.dart';
import 'package:rattle/settings/widgets/section_graphic_theme.dart';
import 'package:rattle/settings/widgets/section_partition.dart';
import 'package:rattle/settings/widgets/section_random_seed.dart';
import 'package:rattle/settings/widgets/section_session.dart';
import 'package:rattle/providers/cleanse.dart';
import 'package:rattle/providers/keep_in_sync.dart';
import 'package:rattle/providers/normalise.dart';
import 'package:rattle/providers/partition.dart';
import 'package:rattle/providers/settings.dart';
import 'package:rattle/settings/utils/handle_cancel_button.dart';

class SettingsDialog extends ConsumerStatefulWidget {
  const SettingsDialog({super.key});

  @override
  SettingsDialogState createState() => SettingsDialogState();
}

class SettingsDialogState extends ConsumerState<SettingsDialog> {
  @override
  void initState() {
    super.initState();

    _loadSettings();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Load settings from shared preferences and update providers.

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // Update providers with saved toggle states.

    ref.read(cleanseProvider.notifier).state =
        prefs.getBool('cleanse') ?? ref.read(cleanseProvider);

    ref.read(normaliseProvider.notifier).state =
        prefs.getBool('normalise') ?? ref.read(normaliseProvider);

    ref.read(partitionProvider.notifier).state =
        prefs.getBool('partition') ?? ref.read(partitionProvider);

    // Update "Keep in Sync" state.

    ref.read(keepInSyncProvider.notifier).state =
        prefs.getBool('keepInSync') ?? true;

    // Update "Session Control" state.

    ref.read(askOnExitProvider.notifier).state =
        prefs.getBool('askOnExit') ?? true;

    final platformDefault = Platform.isWindows ? 'start' : 'open';

    // Set initial value if the provider state is empty.

    ref.read(imageViewerSettingProvider.notifier).state =
        prefs.getString('imageViewerApp') ?? platformDefault;

    ref.read(randomPartitionSettingProvider.notifier).state =
        prefs.getBool('randomPartition') ?? false;

    ref.read(useValidationSettingProvider.notifier).state =
        prefs.getBool('useValidation') ?? false;

    _loadRandomSeed();

    _loadPartition();
  }

  Future<void> _loadRandomSeed() async {
    final prefs = await SharedPreferences.getInstance();
    final seed = prefs.getInt('randomSeed') ?? 42;
    ref.read(randomSeedSettingProvider.notifier).state = seed;
  }

  Future<void> _loadPartition() async {
    final prefs = await SharedPreferences.getInstance();
    final train = prefs.getInt('train') ?? 70;
    ref.read(partitionTrainProvider.notifier).state = train;

    final tune = prefs.getInt('tune') ?? 15;
    ref.read(partitionTuneProvider.notifier).state = tune;

    final test = prefs.getInt('test') ?? 15;
    ref.read(partitionTestProvider.notifier).state = test;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Stack(
          children: [
            Container(
              width: size.width,
              height: size.height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Settings header.
                      Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(),
                      DatasetToggles(),
                      GraphicTheme(),
                      Partition(),
                      RandomSeed(),
                      Session(),
                    ],
                  ),
                ),
              ),
            ),

            // Close button for the dialog.

            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => handleCancelButton(context, ref),
                tooltip: 'Cancel',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
