// capture whether the dataset has been loaded

import 'package:flutter_riverpod/flutter_riverpod.dart';

final datasetLoaded = StateProvider<bool>((ref) => false);