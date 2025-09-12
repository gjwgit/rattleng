import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/providers/vars/roles.dart';
import 'package:rattle/providers/vars/types.dart';
import 'package:rattle/utils/get_target.dart';
import 'package:rattle/utils/get_unique_columns.dart';
import 'package:rattle/providers/meta_data.dart';
import 'package:rattle/utils/is_numeric.dart';
import 'package:rattle/r/extract_vars.dart';

// Set initial role for a variable.

void _setInitialRole(VariableInfo column, WidgetRef ref) {
  String name = column.name.toLowerCase();

  // Default is INPUT unless a prefix is found.

  Role role = Role.input;

  if (name.startsWith('risk_')) role = Role.risk;
  if (name.startsWith('ignore_')) role = Role.ignore;
  if (name.startsWith('target_')) role = Role.target;

  ref.read(rolesProvider.notifier).state[column.name] = role;
  ref.read(typesProvider.notifier).state[column.name] =
      isNumeric(column.type) ? Type.numeric : Type.categoric;
}

// Treat the last variable as a TARGET by default. We will eventually
// implement Rattle heuristics to identify the TARGET if the final
// variable has more than 5 levels. If so we'll check if the first
// variable looks like a TARGET (another common practise) and if not
// then no TARGET will be identified by default.

void _setTargetRole(List<VariableInfo> vars, WidgetRef ref) {
  String target = getTarget(ref);

  if (target == 'NULL') {
    ref.read(rolesProvider.notifier).state[vars.last.name] = Role.target;
  } else if (target != '""') {
    // TODO 20241216 gjw HOW DOES target BECOME '""' - TO BE FIXED.

    ref.read(rolesProvider.notifier).state[target] = Role.target;
  }
}

void _setIdentRole(WidgetRef ref) {
  // Any variables that have a unique value for every row in the dataset is
  // considered to be an IDENTifier.

  for (var id in getUniqueColumns(ref)) {
    ref.read(rolesProvider.notifier).state[id] = Role.ident;
  }

  Map metaData = ref.read(metaDataProvider);

  // 20241211 gjw A hueristic that says if there are only two columns in the
  // dataset, expect it to be a basket dataset for association rule
  // analysis. Set the firt column as the basket identifier (IDENT) and the
  // second column as the basket item (TARGET). As we move away from the
  // DATASET tab we also set the BASKETS checkbox in the ASSOCIATE feature to
  // match this heuristic. That is done in `lib/home.dart`.

  if (metaData.length == 2) {
    ref.read(rolesProvider.notifier).state[metaData.keys.first] = Role.ident;
    ref.read(rolesProvider.notifier).state[metaData.keys.last] = Role.target;
  }
}

// Initialize roles.

void initialiseRoles(
  List<VariableInfo> vars,
  List<String> highVars,
  Map<String, Role> currentRoles,
  WidgetRef ref,
) {
  if (currentRoles.isEmpty && vars.isNotEmpty) {
    for (var column in vars) {
      _setInitialRole(column, ref);
    }
    _setTargetRole(vars, ref);
    _setIdentRole(ref);

    // 20241213 gjw Let's turn off the IGNORE heursitic for now. Leave it to a
    // user to decide. For the PROTEIN dataset we want COUNTRY to be IDENT r
    // TARGET rather than IGNORE.

    // _setIgnoreRoleForHighVars(highVars, ref);
  }
}
