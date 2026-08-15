/// The INTERACTIVE button of the EVALUATE tab.
///
/// Time-stamp: "Saturday 2026-08-15 10:12:00 +1000 Graham Williams"
///
/// Copyright (C) 2026, Togaware Pty Ltd.
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://opensource.org/license/gpl-3-0
///
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
/// Authors: Graham Williams

library;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';

import 'package:rattle/features/evaluate/interactive_models.dart';
import 'package:rattle/features/evaluate/interactive_popup.dart';

/// Popup the INTERACTIVE prediction window for a single observation.
///
/// The button is disabled until a model that has been built is ticked, since
/// there would be nothing to predict with, and the tooltip then says so. The
/// tooltip shows on the disabled button because [MarkdownTooltip] wraps the
/// button rather than being a property of it.

class InteractiveButton extends ConsumerWidget {
  const InteractiveButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool enabled = interactiveModelScripts(ref).isNotEmpty;

    return MarkdownTooltip(
      message: '''

      **Interactive**

      Tap here to popup a window where you can enter a value for each of the
      model input variables and then predict the outcome for that one
      observation. Each model you have ticked above predicts it, so you can
      compare what the models make of the same observation.${enabled ? '' : '''


      You will need to tick a model above before you can predict with it,
      having built it in the **Model** tab.'''}

      ''',
      child: ElevatedButton(
        onPressed: enabled
            ? () => showDialog(
                  context: context,
                  builder: (context) => const InteractivePopup(),
                )
            : null,
        child: const Text('Interactive'),
      ),
    );
  }
}
