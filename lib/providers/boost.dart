/// Providers for parameters boost settings.
///
/// Time-stamp: <Sunday 2024-08-18 08:41:34 +1000 Graham Williams>
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
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
/// Authors: Zheyuan Xu

library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

final maxDepthBoostProvider = StateProvider<int>((ref) => 6);
final minSplitBoostProvider = StateProvider<int>((ref) => 20);
final complexityBoostProvider = StateProvider<double>((ref) => 0.01);
final xValueBoostProvider = StateProvider<int>((ref) => 10);
final learningRateBoostProvider = StateProvider<double>((ref) => 0.3);
final threadsBoostProvider = StateProvider<int>((ref) => 2);
final iterationsBoostProvider = StateProvider<int>((ref) => 50);
final objectiveBoostProvider =
    StateProvider<String>((ref) => 'binary:logistic');
final algorithmBoostProvider = StateProvider<String>((ref) => 'Extreme');
