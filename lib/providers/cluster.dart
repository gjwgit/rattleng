/// A provider for the parameters for cluster.
///
/// Time-stamp: <Monday 2024-12-02 09:32:57 +1100 Graham Williams>
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

final linkClusterProvider = StateProvider<String>((ref) => 'ward');
final numberClusterProvider = StateProvider<int>((ref) => 10);
final processorClusterProvider = StateProvider<int>((ref) => 1);
final reScaleClusterProvider = StateProvider<bool>((ref) => true);
final runClusterProvider = StateProvider<int>((ref) => 1);
final typeClusterProvider = StateProvider<String>((ref) => 'KMeans');
final distanceClusterProvider = StateProvider<String>((ref) => 'euclidean');

// TODO 20241202 gjw REPLACE WITH RANDOM_SEED as in #622

final randomSeedProvider = StateProvider<int>((ref) => 42);
