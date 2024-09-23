import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define a provider for PageController
final pageControllerProvider = StateProvider<PageController>((ref) {
  return PageController();
});
