/// A provider for the parameters for neural.
///
/// Time-stamp: <Thursday 2024-10-10 08:26:18 +1100 Graham Williams>
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

final nnetSizeLayerProvider = StateProvider<int>((ref) => 10);
final maxitProvider = StateProvider<int>((ref) => 100);
final nnetSkipProvider = StateProvider<bool>((ref) => false);
final nnetTraceProvider = StateProvider<bool>((ref) => false);
final neuralAlgorithmProvider = StateProvider<String>((ref) => 'nnet');
final neuralnetErrorFctProvider = StateProvider<String>((ref) => 'sse');
final neuralnetActionFctProvider = StateProvider<String>((ref) => 'logistic');
final neuralThresholdProvider = StateProvider<double>((ref) => 0.0100);
