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

  // Function to save the PDF with a user-selected directory and custom file name.

  Future<void> _saveAsPdf(BuildContext context) async {
    // Create a PDF document.

    final pdf = pw.Document();

    // Split the content into lines to format them better.

    List<String> lines = content.split('\n');

    // Add the title and content to the PDF page.

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: lines.map((line) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 4),
                  child: pw.Text(
                    line.trim(),
                    style: pw.TextStyle(fontSize: 5),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );

    // Prompt the user to select a directory and specify the file name.

    try {
      // Pick a directory to save the PDF file.

      String? directoryPath = await FilePicker.platform.getDirectoryPath();

      if (directoryPath != null) {
        // Show a dialog to enter the custom file name.

        TextEditingController fileNameController = TextEditingController();

        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Enter File Name'),
              content: TextField(
                controller: fileNameController,
                decoration: const InputDecoration(hintText: 'File Name'),
              ),
              actions: [
                TextButton(
                  child: const Text('Save'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );

        // Use the custom file name or a default name if not provided.

        String fileName = fileNameController.text.isNotEmpty
            ? fileNameController.text
            : 'default_name';
        String filePath = '$directoryPath/$fileName.pdf';
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
        // Handle case when no directory is selected.

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No directory selected.'),
          ),
        );
      }
    } catch (e) {
      // Handle errors if something goes wrong.

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save PDF: $e'),
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

//       if (line isNotEmpty) {
//         line = '${line[0].toUpperCase()}${line.substring(1)}';
//       }

//       return index == 0 ? line : '    $line';
//     }).toList();

//     // Join the lines with line breaks
//     return formattedLines.join('\n');
//   }
}
