/// A provider manages the state of punctuation checkbox
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

final punctuationProvider = StateProvider<bool>((ref) => false);
