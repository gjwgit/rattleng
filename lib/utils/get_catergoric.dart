import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rattle/providers/types.dart';

List<String> getCategoric(WidgetRef ref) {
  // The typesProvider lists the types for the different variables which we
  // need to know for parsing the R scripts.

  Map<String, Type> roles = ref.read(typesProvider);

  List<String> rtn = [];
  roles.forEach((key, value) {
    if (value == Type.categoric) {
      rtn.add(key);
    }
  });
  
  return rtn;
}
