import 'package:rattle/r/execute.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

List<String> rExtractTypes(WidgetRef ref, String string) {
  String script = "print(Hello world!)";
  rExcecute(ref, script);
  print("The code was executed");
  return List.empty();
}
