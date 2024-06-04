/// A provider manages the state of max word
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

final maxWordProvider = StateProvider<String>((ref) => '');
