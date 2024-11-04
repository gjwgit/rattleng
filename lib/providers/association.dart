/// Providers for parameters association settings.
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

final basketsAssociationProvider = StateProvider<bool>((ref) => false);
final confidenceAssociationProvider = StateProvider<double>((ref) => 0.1);
final interestMeasuresAssociationProvider = StateProvider<int>((ref) => 20);
final minLengthAssociationProvider = StateProvider<int>((ref) => 2);
final sortByAssociationProvider = StateProvider<String>((ref) => 'Support');
final supportAssociationProvider = StateProvider<double>((ref) => 0.1);
