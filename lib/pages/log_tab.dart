/// The LOG tab page.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Sunday 2023-08-27 15:11:09 +1000 Graham Williams>
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

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rattle/constants/app.dart';
import 'package:rattle/helpers/load_asset.dart';
import 'package:rattle/helpers/r.dart';
import 'package:rattle/widgets/log/log_info.dart';
import 'package:rattle/widgets/log/log_text.dart';
import 'package:rattle/widgets/markdown_file.dart';

final logController = TextEditingController();

class LogTab extends StatelessWidget {
  const LogTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: 4,
          child: LogInfo(),
        ),
        Expanded(
          flex: 7,
          child: LogText(),
        ),
      ],
    );
  }
}
