/// A provider for the state of dataset and its package to be loaded
///
/// Time-stamp: "Thursday 2025-03-27 13:37:30 +1100 Graham Williams"
///
/// Copyright (C) 2023, Togaware Pty Ltd.
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
/// Authors: Yixiang Yin, Kevin Wang
library;

import 'package:flutter_riverpod/legacy.dart';

final datasetProvider = StateProvider<String>((ref) => '');
final packageProvider = StateProvider<String>((ref) => '');

final dsnameProvider = StateProvider<String>((ref) => '');
