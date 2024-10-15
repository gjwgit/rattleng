/// Helper widget to build the common text based pages.
//
// Time-stamp: <Thursday 2024-09-26 08:33:53 +1000 Graham Williams>
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
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
          // Add the button to view and save as PDF
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
              ElevatedButton.icon(
                icon: Icon(Icons.picture_as_pdf),
                label: Text('Save as PDF'),
                onPressed: () => _saveAsPdf(context),
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

  // Function to save the content as a PDF file and open it.
  Future<void> _saveAsPdf(BuildContext context) async {
    final pdf = pw.Document();

    // Apply word wrapping to the content using the wordWrap function
    String wrappedContent = wordWrap(content, width: 60);

    // Add the title and content to the PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(title,
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),

            // Use wrapped content to ensure proper word wrapping in the PDF
            pw.Text(wrappedContent, style: pw.TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );

    // Save the PDF to a file
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/text_page.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    // Show a SnackBar with the file path and open the PDF
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
  }

//   // Utility function to capitalize each line, add line spacing, and indent lines.

//   String _formatContent(String content) {
//     final lines = content.split('\n');

//     final formattedLines = lines.asMap().entries.map((entry) {
//       int index = entry.key;
//       String line = entry.value.trim();

//       // Capitalize the first letter of each line.

//       if (line isNotEmpty) {
//         line = '${line[0].toUpperCase()}${line.substring(1)}';
//       }

//       return index == 0 ? line : '    $line';
//     }).toList();

//     // Join the lines with line breaks
//     return formattedLines.join('\n');
//   }
}
