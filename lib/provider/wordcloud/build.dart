// record whether the wordcloud model has been built
// enable reloading
import 'package:flutter_riverpod/flutter_riverpod.dart';

final wordcloudBuildProvider = StateProvider<String>((ref) => "");
