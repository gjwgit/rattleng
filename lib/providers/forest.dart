/// A provider for the parameters for forest.
///
/// Time-stamp: <Monday 2025-05-05 09:02:07 +1000 Graham Williams>
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
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
// this program.  If not, see <https://www.gnu.org/licenses/>.
///
/// Authors: Zheyuan Xu

library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/providers/tree.dart';

final algorithmForestProvider =
    StateProvider<AlgorithmType>((ref) => AlgorithmType.traditional);
final forestSampleSizeProvider = StateProvider<String?>((ref) => null);
final imputeForestProvider = StateProvider<bool>((ref) => true);
final maxRulesForestProvider = StateProvider<int>((ref) => 10);
// The following should be 10 as in RattleV5 but was accidently set as 4 in
// RattleV6 and 3 for COMP3425 labs. For now set to 3 for the lab and then after
// the course revert to 10. (gjw 20250505)
final predictorNumForestProvider = StateProvider<int>((ref) => 3);
final treeNumForestProvider = StateProvider<int>((ref) => 500);
final treeNoForestProvider = StateProvider<int>((ref) => 1);
