/// A provider manages the state of min frequency
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

final minFreqProvider = StateProvider<String>((ref) => '');
