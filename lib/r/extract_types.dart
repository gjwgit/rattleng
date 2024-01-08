import 'package:rattle/r/execute.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Return a list of String containing the type of the variable

List<String> rExtractTypes(WidgetRef ref) {
  String script = "classes<-unname(sapply(ds,class))";
  rExecute(ref, script);
  print("The code was executed");
  return List.empty();
}
