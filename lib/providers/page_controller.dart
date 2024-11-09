/// A provider for page controller.
///
/// Time-stamp: <Wednesday 2024-10-09 09:43:42 +1100 Graham Williams>
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
/// Authors: Kevin Wang
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define a provider for PageController.

final associationControllerProvider = StateProvider<PageController>((ref) {
  return PageController();
});

final pageControllerProvider = StateProvider<PageController>((ref) {
  return PageController();
});

final summaryPageControllerProvider = StateProvider<PageController>((ref) {
  return PageController();
});

final visualPageControllerProvider = StateProvider<PageController>((ref) {
  return PageController();
});

final missingPageControllerProvider = StateProvider<PageController>((ref) {
  return PageController();
});

final correlationPageControllerProvider = StateProvider<PageController>((ref) {
  return PageController();
});

final testsPageControllerProvider = StateProvider<PageController>((ref) {
  return PageController();
});

final imputePageControllerProvider = StateProvider<PageController>((ref) {
  return PageController();
});

final rescalePageControllerProvider = StateProvider<PageController>((ref) {
  return PageController();
});

final recodePageControllerProvider = StateProvider<PageController>((ref) {
  return PageController();
});

final clusterPageControllerProvider = StateProvider<PageController>((ref) {
  return PageController();
});

final cleanupPageControllerProvider = StateProvider<PageController>((ref) {
  return PageController();
});

final forestPageControllerProvider = StateProvider<PageController>((ref) {
  return PageController();
});

final neuralPageControllerProvider = StateProvider<PageController>((ref) {
  return PageController();
});

final boostPageControllerProvider = StateProvider<PageController>((ref) {
  return PageController();
});

final treePageControllerProvider = StateProvider<PageController>((ref) {
  return PageController();
});

final wordcloudPageControllerProvider = StateProvider<PageController>((ref) {
  return PageController();
});

final svmPageControllerProvider = StateProvider<PageController>((ref) {
  return PageController();
});
