/// Helper widget to build the common text based pages.
//
// Time-stamp: <Wednesday 2025-01-08 20:25:19 +1100 Graham Williams>
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
/// Authors: Graham Williams

library;

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';

import 'package:rattle/constants/spacing.dart';
import 'package:rattle/constants/style.dart';
import 'package:rattle/constants/sunken_box_decoration.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';

class TextPage extends StatelessWidget {
  final String title;
  final String content;

  const TextPage({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    // Create a ScrollController for horizontal scrolling.

    final ScrollController horizontalScrollController = ScrollController();

    // Modify the content to format each line, capitalize it, and add word wrap.

    // String formattedContent = _formatContent(content);

    return Container(
      decoration: sunkenBoxDecoration,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add the button to view and save as PDF.

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MarkdownBody(
                data: wordWrap(title),
                selectable: true,
                onTapLink: (text, href, title) {
                  final Uri url = Uri.parse(href ?? '');
                  launchUrl(url);
                },
              ),

              // Wrap the buttons in a Row to keep them close together.
              Row(
                children: [
                  // Button to generate and open PDF.

                  MarkdownTooltip(
                    message: '''

                        **Open.** Tap here to open the data of this page in a
                          separate window to the Rattle app itself. This allows
                          you to retain a view of the information while you
                          navigate through other data and analyses.

                        ''',
                    child: IconButton(
                      onPressed: () => _generateAndOpenPdf(context),
                      icon: Icon(
                        Icons.open_in_new,
                        color: Colors.blue,
                      ),
                    ),
                  ),

                  // Add a small space between the buttons.
                  SizedBox(width: 8),

                  // Button to save as PDF.

                  MarkdownTooltip(
                    message: '''

                        **Save.** Tap here to save the information in this text
                          page to a **pdf** document.

                        ''',
                    child: IconButton(
                      onPressed: () => _saveAsPdf(context),
                      icon: Icon(
                        Icons.save,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              trackVisibility: true,

              // Attach the horizontal controller.

              controller: horizontalScrollController,
              child: SingleChildScrollView(
                // Attach a vertical controller for independent scrolling.

                controller: ScrollController(),
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: horizontalScrollController,
                  child: Container(
                    // Ensure width matches the full container.

                    width: MediaQuery.of(context).size.width,
                    child: SelectableText(
                      content,
                      style: monoTextStyle,
                      textAlign: TextAlign.left,
                      // Handle text selection changes in the content.

                      onSelectionChanged: (selection, cause) {
                        // Only copy text when user long presses or drags to select.

                        if (cause == SelectionChangedCause.longPress ||
                            cause == SelectionChangedCause.drag) {
                          // Extract the selected text using the selection range.

                          final selectedText = content.substring(
                            selection.start,
                            selection.end,
                          );
                          // If text was actually selected, copy it to clipboard.

                          if (selectedText.isNotEmpty) {
                            Clipboard.setData(
                              ClipboardData(text: selectedText),
                            );
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 20240812 gjw Add a bottom spacer to leave a gap for the page
          // navigation when scrolling to the bottom of the page so that it can
          // be visible in at least some part of any very busy pages.

          textPageBottomGap,

          // 20240812 gjw Add a divider to mark the end of the text page.

          const Divider(
            thickness: 15,
            color: Color(0XFFBBDEFB),
            indent: 0,
            endIndent: 20,
          ),
        ],
      ),
    );
  }

  ////////////////////////////////////////////////////////////////////////
  // PDF Creation

  /// Extract the title from the title string. The actual title is expected to
  /// be the fist line and begins with the markdown #. We strip the #. If not
  /// title is found the return the empty string.

  String extractTitle(String title) {
    List<String> lines = title.split('\n');

    for (String line in lines) {
      // Trim leading and trailing spaces and check if the string is not empty.

      if (line.trim().isNotEmpty) {
        // Use a regular expression to check if the string starts with spaces
        // followed by a #.

        RegExp regExp = RegExp(r'^\s*#(.*)');

        // If the string matches the pattern, return the part after the # and
        // spaces.  Return an empty string if the first non-empty string doesn't
        // start with #

        Match? match = regExp.firstMatch(line);

        return match != null ? match.group(1)?.trim() ?? '' : '';
      }
    }

    return '';
  }

  /// Fromt he title string remove the first line title that begins with # and
  /// format the remainder to add to the PDF page.

  String extractCommentary(String title) {
    bool foundTitle = false;
    List<String> result = [];
    List<String> lines = title.split('\n');

    // Use a regular expression to check if the string starts with spaces
    // followed by a #.

    RegExp regExp = RegExp(r'^\s*#(.*)');

    for (String line in lines) {
      // Check if the string is the first non-empty line that starts with
      // optional space followed by #.

      if (!foundTitle) {
        if (regExp.hasMatch(line)) {
          foundTitle = true;
          continue;
        }
      } else {
        result.add(line);
      }
    }

    // Replace matches of [XXXX](YYYY) with the desired format.

    String fin = result.join().trim().replaceAll(RegExp(r'\s+'), ' ');
    regExp = RegExp(r'\[([^\]]+)\]\(([^)]+)\)');
    fin = fin.replaceAllMapped(regExp, (Match match) {
      String text = match.group(1)!; // XXXXX
      // String link = match.group(2)!; // YYYY

      return text;
    });

    return fin;
  }

// Generate the PDF document with given content.

  Future<pw.Document> _createPdf(String content) async {
    String extractedTitle = extractTitle(title);

    // Load the 'RobotoMono' font from assets.

    final fixed = pw.Font.ttf(
      await rootBundle.load('assets/fonts/RobotoMono-Regular.ttf'),
    );

    final sans = pw.Font.ttf(
      await rootBundle.load('assets/fonts/OpenSans-Regular.ttf'),
    );

    // A fallback font that supports the unicode block characters from the skimr output.

    final dejavu = pw.Font.ttf(
      await rootBundle.load('assets/fonts/DejaVuSans.ttf'),
    );

    final pdf = pw.Document();

    // Split the content into lines for formatting.

    List<String> lines = content.split('\n');

    // Add the title and content to the PDF page.

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return [
            // Add the title at the top of the document.

            pw.Text(
              extractedTitle,
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                font: sans,
              ),
            ),

            pw.SizedBox(height: 10),

            // Add a commentary text.

            pw.Text(
              extractCommentary(title),
              style: pw.TextStyle(
                fontSize: 8,
                fontStyle: pw.FontStyle.italic,
                font: sans,
              ),
            ),

            pw.SizedBox(height: 10),

            // Add the content lines.

            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: lines.map((line) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 4),
                  child: pw.Text(
                    line,
                    style: pw.TextStyle(
                      fontSize: 6,
                      height: 1.2,
                      font: fixed,
                      fontFallback: [dejavu],
                    ),
                  ),
                );
              }).toList(),
            ),
          ];
        },
      ),
    );

    return pdf;
  }
// Function to generate and open the PDF in a separate window.

  Future<void> _generateAndOpenPdf(BuildContext context) async {
    // Create the PDF document using the helper function.

    final pdf = await _createPdf(content);

    // Get the temporary directory path.

    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/text_${Random().nextInt(10000)}.pdf';

    // Save the PDF file to the temporary directory.

    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    // Open the PDF file using the operating system's command.

    if (Platform.isWindows) {
      await Process.run('start', [filePath], runInShell: true);
    } else {
      await Process.run('open', [filePath]);
    }
  }

// Function to save the PDF with a user-selected directory and custom file name.

  Future<void> _saveAsPdf(BuildContext context) async {
    // Create the PDF document using the helper function.

    final pdf = await _createPdf(content);

    // Use FilePicker to select a save location and file name.

    String? filePath = await FilePicker.platform.saveFile(
      dialogTitle: 'Save PDF',
      fileName: 'rattle_text_${Random().nextInt(100)}.pdf',
    );

    // Check if a file path was provided.

    if (filePath != null) {
      final file = File(filePath);

      // Write the PDF as bytes.

      await file.writeAsBytes(await pdf.save());

      // Show a SnackBar with the file path and open the PDF.

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF saved as $filePath'),
          action: SnackBarAction(
            label: 'Open',
            onPressed: () {
              launchUrl(Uri.file(filePath));
            },
          ),
        ),
      );
    } else {
      // Handle case when no file is selected.

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No file selected.'),
        ),
      );
    }
  }
}
