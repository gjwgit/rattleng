/// A provider manages the state of stopword checkbox
import 'package:flutter_riverpod/flutter_riverpod.dart';

final stopwordProvider = StateProvider<bool>((ref) => false);
