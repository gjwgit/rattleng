import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define a provider to store selected row indices
final selectedRowIndicesProvider = StateProvider<Set<int>>((ref) => {});