/// Save a displayed plot to a file chosen by the user.
//
// Time-stamp: "Tuesday 2026-09-01 09:00:00 +1000 Graham Williams"
//
/// Copyright (C) 2026, Togaware Pty Ltd
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
/// Authors: Graham Williams

library;

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:rattle/utils/select_file.dart';
import 'package:rattle/utils/show_ok.dart';

// Convert the file [svgPath] and return the image bytes in PNG format.
//
// Throws an [Exception] if the conversion fails.

Future<ByteData> _svgToImageBytes(String svgPath) async {
  final svgString = await File(svgPath).readAsString();

  final pictureInfo = await vg.loadPicture(SvgStringLoader(svgString), null);

  final size = pictureInfo.size;

  final image = await pictureInfo.picture.toImage(
    size.width.toInt(),
    size.height.toInt(),
  );

  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

  if (byteData == null) {
    throw Exception('Failed to convert the SVG to image bytes.');
  }

  return byteData;
}

// Export the SVG file [svgPath] into a PDF file [pdfPath].

Future<void> _exportToPdf(String svgPath, String pdfPath) async {
  final pngBytes = await _svgToImageBytes(svgPath);

  final pdf = pw.Document();
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Image(pw.MemoryImage(pngBytes.buffer.asUint8List())),
        );
      },
    ),
  );

  await File(pdfPath).writeAsBytes(await pdf.save());
}

// Export the SVG file [svgPath] into a PNG file [pngPath].

Future<void> _exportToPng(String svgPath, String pngPath) async {
  final pngBytes = await _svgToImageBytes(svgPath);

  await File(pngPath).writeAsBytes(pngBytes.buffer.asUint8List());
}

/// Prompt for a filename and save the plot found at [sourcePath] to it.
///
/// The plot is saved in the format named by the filename extension the user
/// chooses: **svg**, **pdf**, or **png**. A SnackBar confirms the save and an
/// error dialog reports any failure.
///
/// Every step is wrapped in a try/catch. Previously the save was awaited from
/// the button's `onPressed` with no error handling at all, so anything that
/// went wrong (a filesystem permission on macOS, a failed SVG render) was
/// swallowed by the framework and the plot silently did not get saved. The
/// written file is also checked to actually exist and to be non-empty, since a
/// write that reports success without producing a file would otherwise be just
/// as silent. (gjw 20260901)

Future<void> savePlot(BuildContext context, String sourcePath) async {
  final String? pathToSave = await selectFile(
    defaultFileName: sourcePath.split('/').last,
    allowedExtensions: ['svg', 'pdf', 'png'],
  );

  // The user cancelled the file chooser so there is nothing to report.

  if (pathToSave == null) return;

  final String extension = pathToSave.split('.').last.toLowerCase();

  try {
    switch (extension) {
      case 'svg':
        await File(sourcePath).copy(pathToSave);

      case 'pdf':
        await _exportToPdf(sourcePath, pathToSave);

      case 'png':
        // Only an SVG source needs converting. A PNG source is simply copied.

        if (sourcePath.toLowerCase().endsWith('.svg')) {
          await _exportToPng(sourcePath, pathToSave);
        } else {
          await File(sourcePath).copy(pathToSave);
        }

      default:
        // The user provided an unsupported filename extension.

        if (context.mounted) {
          showOk(
            title: 'Error',
            context: context,
            content: '''

              An unsupported filename extension was provided: .$extension.
              Please try again and select a filename with one of the supported
              extensions: .svg, .pdf, or .png.

              ''',
          );
        }

        return;
    }

    // Confirm the file is actually there and has content.

    final File saved = File(pathToSave);

    if (!await saved.exists() || await saved.length() == 0) {
      throw FileSystemException('No file was written.', pathToSave);
    }
  } catch (e) {
    if (context.mounted) {
      showOk(
        title: 'Save Failed',
        context: context,
        content: '''

          The plot could not be saved to **$pathToSave**. You may not have
          permission to write to that folder, in which case try saving to a
          folder of your own, like your Documents or Desktop folder.

          The error reported was:

          $e

          ''',
      );
    }

    return;
  }

  if (!context.mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Plot saved as $pathToSave')),
  );
}
