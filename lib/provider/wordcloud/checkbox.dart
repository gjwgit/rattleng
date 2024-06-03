/// A provider manages the state of the checkbox for wordcloud
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

final checkboxProvider = StateProvider<bool>((ref) => false);
