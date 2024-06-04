/// A provider manages the state of stem checkbox
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

final stemProvider = StateProvider<bool>((ref) => false);
