// providers/page_index.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// State provider to hold the current page index
final pageIndexProvider = StateProvider<int>((ref) => 0);
