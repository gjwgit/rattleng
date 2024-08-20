/// R Scripts: Support for running a script.
///
/// Time-stamp: <Tuesday 2024-08-20 16:51:42 +1000 Graham Williams>
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU General Public License as published by the Free Software
// Foundation, either version 3 of the License, or (at your option) any later
// version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program.  If not, see <https://www.gnu.org/licenses/>.
///
/// Authors: Graham Williams, Yixiang Yin
library;

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rattle/providers/number.dart';
import 'package:rattle/utils/get_ignored.dart';
import 'package:rattle/utils/to_r_vector.dart';
import 'package:universal_io/io.dart' show Platform;

import 'package:rattle/constants/temp_dir.dart';
import 'package:rattle/providers/cleanse.dart';
import 'package:rattle/providers/complexity.dart';
import 'package:rattle/providers/group_by.dart';
import 'package:rattle/providers/imputed.dart';
import 'package:rattle/providers/loss_matrix.dart';
import 'package:rattle/providers/max_depth.dart';
import 'package:rattle/providers/min_bucket.dart';
import 'package:rattle/providers/min_split.dart';
import 'package:rattle/providers/interval.dart';
import 'package:rattle/providers/normalise.dart';
import 'package:rattle/providers/partition.dart';
import 'package:rattle/providers/path.dart';
import 'package:rattle/providers/priors.dart';
import 'package:rattle/providers/pty.dart';
import 'package:rattle/providers/tree_include_missing.dart';
import 'package:rattle/providers/vars/roles.dart';
import 'package:rattle/providers/selected.dart';
import 'package:rattle/providers/selected2.dart';
import 'package:rattle/providers/wordcloud/checkbox.dart';
import 'package:rattle/providers/wordcloud/language.dart';
import 'package:rattle/providers/wordcloud/maxword.dart';
import 'package:rattle/providers/wordcloud/minfreq.dart';
import 'package:rattle/providers/wordcloud/punctuation.dart';
import 'package:rattle/providers/wordcloud/stem.dart';
import 'package:rattle/providers/wordcloud/stopword.dart';
import 'package:rattle/r/strip_comments.dart';
import 'package:rattle/r/strip_header.dart';
import 'package:rattle/utils/debug_text.dart';
import 'package:rattle/utils/get_missing.dart';
import 'package:rattle/utils/timestamp.dart';
import 'package:rattle/utils/update_script.dart';

/// Run the R [script] and append to the [rattle] script.
///
/// Various PARAMETERS that are found in the R script will be replaced with
/// actual values before the code is run. An early approach was to wrap the
/// PARAMETERS within anlg brackets, as in <<PARAMETERS>> but then the R scripts
/// do not run standalone. Whlist it did ensure the parameters were properly
/// mapped, it is useful to be able to run the scripts as is outside of
/// rattleNG. So decided to remove the angle brackets. The scripts still can not
/// tun standalone as such since they will have undefined vairables, but we can
/// define the variables and then run the scripts.

void rSource(BuildContext context, WidgetRef ref, String script) async {
  // Initialise the state variables used here.

  bool checkbox = ref.read(checkboxProvider);
  bool cleanse = ref.read(cleanseProvider);
  bool normalise = ref.read(normaliseProvider);
  bool partition = ref.read(partitionProvider);
  bool punctuation = ref.read(punctuationProvider);
  bool stem = ref.read(stemProvider);
  bool stopword = ref.read(stopwordProvider);

  String groupBy = ref.read(groupByProvider);
  String imputed = ref.read(imputedProvider);
  String language = ref.read(languageProvider);
  String maxWord = ref.read(maxWordProvider);
  String minFreq = ref.read(minFreqProvider);
  String path = ref.read(pathProvider);
  String selected = ref.read(selectedProvider);
  String selected2 = ref.read(selected2Provider);

  int minSplit = ref.read(minSplitProvider);
  int maxDepth = ref.read(maxDepthProvider);
  String priors = ref.read(priorsProvider);
  bool includingMissing = ref.read(treeIncludeMissingProvider);
  int minBucket = ref.read(minBucketProvider);
  double complexity = ref.read(complexityProvider);
  String lossMatrix = ref.read(lossMatrixProvider);

  int interval = ref.read(intervalProvider);

  // First obtain the text from the script.

  debugText('R SOURCE', '$script.R');

  String asset = 'assets/r/$script.R';
  String code = await DefaultAssetBundle.of(context).loadString(asset);
  // var code = File('assets/r/$script.R').readAsStringSync();

  // Process template variables.

  code = code.replaceAll('TIMESTAMP', 'RattleNG ${timestamp()}');

  // Populate the VERSION.

  PackageInfo info = await PackageInfo.fromPlatform();

  code = code.replaceAll('VERSION', info.version);

  code = code.replaceAll('FILENAME', path);

  // TODO 20240630 gjw EVENTUALLY SELECTIVELY REPLACE
  // AS REQUIRED FOR THE CURRENT FEATURE.

  code = code.replaceAll('TEMPDIR', tempDir);

  ////////////////////////////////////////////////////////////////////////
  // CLEANUP
  ////////////////////////////////////////////////////////////////////////

  // TODO 20240809 yyx MOVE COMPUTATION ELSEWHERE IF TOO SLOW.

  List<String> ignoredVars = getIgnored(ref);
  String ignoredVarsString = toRVector(ignoredVars);
  code = code.replaceAll('IGNORE_VARS', ignoredVarsString);

  List<String> result = getMissing(ref);
  code = code.replaceAll('MISSING_VARS', toRVector(result));
  // NEEDS_INIT is true for Windows as main.R does not get run on startup on
  // Windows.

  String needsInit = 'FALSE';
  if (Platform.isWindows) needsInit = 'TRUE';

  code = code.replaceAll('NEEDS_INIT', needsInit);

  ////////////////////////////////////////////////////////////////////////
  // WORD CLOUD
  ////////////////////////////////////////////////////////////////////////

  code = code.replaceAll('RANDOMORDER', checkbox.toString().toUpperCase());
  code = code.replaceAll('STEM', stem ? 'TRUE' : 'FALSE');
  code = code.replaceAll('PUNCTUATION', punctuation ? 'TRUE' : 'FALSE');
  code = code.replaceAll('STOPWORD', stopword ? 'TRUE' : 'FALSE');
  code = code.replaceAll('LANGUAGE', language);

  (minFreq.isNotEmpty && num.tryParse(minFreq) != null)
      ? code = code.replaceAll('MINFREQ', num.parse(minFreq).toInt().toString())
      : code = code.replaceAll('MINFREQ', '1');

  (maxWord.isNotEmpty && num.tryParse(maxWord) != null)
      ? code = code.replaceAll('MAXWORD', num.parse(maxWord).toInt().toString())
      : code = code.replaceAll('MAXWORD', 'Inf');

  // Do we split the dataset? The option is presented on the DATASET GUI, and if
  // set we split the dataset.

  // TODO if (script.contains('^dataset_')) {

  // Do we split the dataset? The option is presented on the DATASET GUI, and if
  // set we split the dataset.

  code = code.replaceAll('SPLIT_DATASET', partition ? 'TRUE' : 'FALSE');

  // Do we want to normalise the dataset? The option is presented on the DATASET
  // GUI, and if set we normalise the dataset's variable names.

  code = code.replaceAll('NORMALISE_NAMES', normalise ? 'TRUE' : 'FALSE');

  // Do we want to cleanse the dataset? The option is presented on the DATASET
  // GUI, and if it is set we will cleanse the dataset columns.

  code = code.replaceAll('CLEANSE_DATASET', cleanse ? 'TRUE' : 'FALSE');

  // TODO 20231016 gjw HARD CODE FOR NOW BUT EVENTUALLY PASSED IN THROUGH THE
  // FUNCTION CALL AS A MAP AS DESCRIBED ABOVE..

  // TODO 20231016 gjw THESE SHOULD BE SET IN THE DATASET TAB AND ACCESS THROUGH
  // PROVIDERS.
  //
  // target
  // risk
  // id
  // split

  // The rolesProvider listes the roles for the different variables which we
  // need to know for parsing the R scripts.

  Map<String, Role> roles = ref.read(rolesProvider);

  // Extract the target variable from the rolesProvider.

  String target = 'NULL';
  roles.forEach((key, value) {
    if (value == Role.target) {
      target = key;
    }
  });

  // If target is NULL then we need to ensure expressions in the R code like
  //
  // target <- "TARGET_VAR"
  //
  // becomes
  //
  // target <- NULL
  //
  // rather then being "NULL" which then indicates a variable called NULL. So
  // handle that special case and then replace any other TARGET_VAR replacement
  // as usual.

  if (target == 'NULL') {
    code = code.replaceAll('"TARGET_VAR"', target);
  }
  code = code.replaceAll('TARGET_VAR', target);

  //code = code.replaceAll('TARGET_VAR', ref.read(rolesProvider));

  // Extract the risk variable from the rolesProvider and use that for now as
  // the variable to visualise.

  String risk = 'NULL';
  roles.forEach((key, value) {
    if (value == Role.risk) {
      risk = key;
    }
  });

  code = code.replaceAll('INTERVAL', interval.toString());
  code = code.replaceAll('NUMBER', ref.read(numberProvider).toString());
  code = code.replaceAll('SELECTED_VAR', selected);

  code = code.replaceAll('SELECTED_2_VAR', selected2);

  code = code.replaceAll('GROUP_BY_VAR', groupBy);

  code = code.replaceAll('IMPUTED_VALUE', imputed);

  //    normalise ? "rain_tomorrow" : "RainTomorrow",
//  );
  code = code.replaceAll('RISK_VAR', risk);

  // Extract the IDENT variables from the rolesProvider.

  String ids = '';
  roles.forEach((key, value) {
    if (value == Role.ident) {
      ids = '$ids${ids.isNotEmpty ? ", " : ""}"$key"';
    }
  });

  code = code.replaceAll('ID_VARS', ids);

  code = code.replaceAll('DATA_SPLIT_TR_TU_TE', '0.7, 0.15, 0.15');

  // TODO if (script == 'model_build_rpart')) {

  // TODO 20231016 gjw THESE SHOULD BE SET IN THE MODEL TAB AND ARE THEN
  // REPLACED WITHING model_build_rpart.R

  code = code.replaceAll(
    ' PRIORS',
    priors.isNotEmpty ? ', prior = c($priors)' : '',
  );
  code = code.replaceAll(
    ' LOSS',
    lossMatrix.isNotEmpty ? ', loss = matrix(c($lossMatrix))' : '',
  );
  code = code.replaceAll(' MAXDEPTH', ' maxdepth = ${maxDepth.toString()}');
  code = code.replaceAll(' MINSPLIT', ' minsplit = ${minSplit.toString()}');
  code = code.replaceAll(' MINBUCKET', ' minbucket = ${minBucket.toString()}');
  code = code.replaceAll(' CP', ' cp = ${complexity.toString()}');

  if (includingMissing) {
    code = code.replaceAll('usesurrogate=0,', '');
    code = code.replaceAll('maxsurrogate=0', '');
  }

  // TODO if (script == 'model_build_random_forest')) {

  code = code.replaceAll('RF_NUM_TREES', '500');
  code = code.replaceAll('RF_MTRY', '4');
  code = code.replaceAll('RF_NA_ACTION', 'randomForest::na.roughfix');

  // Add the code to the script provider so it will be displayed in the script
  // tab and available to be exported there.

  updateScript(
    ref,
    "\n${'#' * 72}\n## -- $script.R --\n${'#' * 72}"
    '\n${rStripHeader(code)}',
  );

  // Run the code without comments.

  code = rStripComments(code);

  ref.read(ptyProvider).write(const Utf8Encoder().convert(code));
}
