/// Helper widget to build the common text based pages.
//
// Time-stamp: <Monday 2024-10-21 14:02:46 +1100 Graham Williams>
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';

import 'package:rattle/constants/spacing.dart';
import 'package:rattle/constants/style.dart';
import 'package:rattle/constants/sunken_box_decoration.dart';
import 'package:rattle/utils/word_wrap.dart';

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
              IconButton(
                onPressed: () => _saveAsPdf(context),
                icon: Icon(
                  Icons.save,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          Expanded(
            child: Scrollbar(
              controller: horizontalScrollController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: horizontalScrollController,
                child: SelectableText(
                  content,
                  style: monoTextStyle,
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ),

          // 20240812 gjw Add a bottom spacer to leave a gap for the page
          // navigation when scrolling to the bottom of the page so that it can
          // be visible in at least some part of any very busy pages.

          textPageBottomSpace,

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

  // Function to save the PDF with a user-selected directory and custom file name.

  Future<void> _saveAsPdf(BuildContext context) async {
    // Load the 'RobotoMono' font from assets.

    final robotoMonoFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/RobotoMono-Regular.ttf'),
    );

    // Create a PDF document.

    final pdf = pw.Document();

    // var mono =
    //     Font.ttf(await rootBundle.load('assets/fonts/RobotoMono-Regular.ttf'));

    // Split the content into lines to format them better.

    List<String> lines = content.split('\n');

    // Add the title and content to the PDF page.

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(-40),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: lines.map((line) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 4),
                  child: pw.Text(
                    line,
                    style: pw.TextStyle(
                      fontSize: 8,
                      height: 1.2,
                      font: robotoMonoFont,
                    ),
                    //style: pw.TextStyle(font: pw.Font.courier(), fontSize: 8),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );

    // Use FilePicker to select a save location and file name.

    String? filePath = await FilePicker.platform.saveFile(
      dialogTitle: 'Save PDF',
      fileName: 'exported.pdf',
    );

    // Check if a file path was provided.

    if (filePath != null) {
      final file = File(filePath);

      // Write the PDF as bytes.

      await file.writeAsBytes(await pdf.save());

      // Show a SnackBar with the file path and open the PDF.

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF saved at $filePath'),
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
//   // Utility function to capitalize each line, add line spacing, and indent lines.

//   String _formatContent(String content) {
//     final lines = content.split('\n');

//     final formattedLines = lines.asMap().entries.map((entry) {
//       int index = entry.key;
//       String line = entry.value.trim();

//       // Capitalize the first letter of each line.

//       if (line.isNotEmpty) {
//         line = '${line[0].toUpperCase()}${line.substring(1)}';
//       }

//       return index == 0 ? line : '    $line';
//     }).toList();

//     // Join the lines with line breaks
//     return formattedLines.join('\n');
//   }
}
