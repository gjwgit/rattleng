/// A button to clear the dataset textfield.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
// Licensed under the GNU General Public License, Version 3 (the "License");
///
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

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:rattle/constants/app.dart';
import 'package:rattle/models/rattle_model.dart';

class DatasetClearTextField extends StatelessWidget {
  const DatasetClearTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.clear),
      onPressed: () {
        // TODO 20230920 gjw POPUP TO ASK IF WANT TO SAVE CURRENT PROJECT.

        RattleModel rattle = Provider.of<RattleModel>(context, listen: false);
        rattle.setPath("");
        rattle.setStatus(statusWelcomeMsg);
        rattle.clearStdout();
        rattle.clearStderr();
      },
    );
  }
}
