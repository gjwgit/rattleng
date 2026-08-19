/// Support for running an R script using R source().
///
// Time-stamp: "Friday 2025-09-12 14:16:42 +1000 Graham Williams"
///
/// Copyright (C) 2023-2025, Togaware Pty Ltd.
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://opensource.org/license/gpl-3-0
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
// this program.  If not, see <https://opensource.org/license/gpl-3-0>.
///
/// Authors: Graham Williams, Yixiang Yin, Zheyuan Xu, Kevin Wang

library;

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rattle/providers/association.dart';
import 'package:rattle/providers/cleanse.dart';
import 'package:rattle/providers/cluster.dart';
import 'package:rattle/providers/evaluate.dart';
import 'package:rattle/providers/forest.dart';
import 'package:rattle/providers/group_by.dart';
import 'package:rattle/providers/ignore_missing_group_by.dart';
import 'package:rattle/providers/imputed.dart';
import 'package:rattle/providers/interval.dart';
import 'package:rattle/providers/linear.dart';
import 'package:rattle/providers/neural.dart';
import 'package:rattle/providers/normalise.dart';
import 'package:rattle/providers/number.dart';
import 'package:rattle/providers/partition.dart';
import 'package:rattle/providers/pty.dart';
import 'package:rattle/providers/r_status.dart';
import 'package:rattle/providers/selected.dart';
import 'package:rattle/providers/selected2.dart';
import 'package:rattle/providers/settings.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/providers/summary_crosstab.dart';
import 'package:rattle/providers/svm.dart';
import 'package:rattle/providers/vars/roles.dart';
import 'package:rattle/providers/visualise.dart';
import 'package:rattle/providers/wordcloud.dart';
import 'package:rattle/r/map_boost.dart';
import 'package:rattle/r/map_global.dart';
import 'package:rattle/r/map_neural.dart';
import 'package:rattle/r/map_rpart.dart';
import 'package:rattle/r/map_word_cloud.dart';
import 'package:rattle/r/strip_comments.dart';
import 'package:rattle/r/strip_header.dart';
import 'package:rattle/r/strip_todo.dart';
import 'package:rattle/utils/debug_text.dart';
import 'package:rattle/utils/get_ignored.dart';
import 'package:rattle/utils/get_missing.dart';
import 'package:rattle/utils/set_status.dart';
import 'package:rattle/utils/to_r_vector.dart';
import 'package:rattle/utils/update_script.dart';

/// Run the R [script] and append to the [rattle] script.
///
/// Various PARAMETERS that are found in the R script will be replaced with
/// actual values before the code is run. An early approach was to wrap the
/// PARAMETERS within angle brackets, as in `<PARAMETERS`> but then the R
/// scripts do not run standalone. Whlist it did ensure the parameters were
/// properly mapped, it is useful to be able to run the scripts as is outside of
/// rattleNG. So decided to remove the angle brackets. The scripts still can not
/// run standalone as such since they will have undefined vairables, but we can
/// define the variables and then run the scripts.
///
/// Reverted to using angle brackets becasue substring parameters were getting
/// replaced if the order was not correct (e.g. FILE and FILENAME). There has
/// not been any call to run the scripts standalone, and if so we could have a
/// separate parameter replacing script. (gjw 20250315)
///

Future<void> rSource(
  BuildContext context,
  WidgetRef ref,
  List<String> scripts,
  //
  // I wrapped the original rSource() as _rSource() within the followig new
  // rSource(). However, oddly this caused issue #938 whereby with Weaher and
  // IGNORE max_temp, CLEANUP -> IGNORED fails because getIgnored() is returning
  // NULL because max_temp is presumably already removed and so not ignored nor
  // is it in recently transformed Role. Putting it into that latter Role
  // partially works but then fails. For now, revert to the direct call to
  // rSource(). (gjw 20250319)
  //
  // ) async {
  //   // In order to explore different execution options we can call _rSource() as a
  //   // private function. The issue is that on Linux the script that is being sent
  //   // to the Console is being truncated on the Console for EVLUATION. And so with
  //   // the recent addition of the 4 ROCR plots (cost, lift, precision,
  //   // sensitivity) I don't get all the plots for multiple models. They are
  //   // actually not being generated into SVG files, seems like because the code is
  //   // not getting to the CONSOLE. Seems like this is the case on my Linux, but
  //   // others are not yet reporting an issue. However, splitting each script out
  //   // to be executed one at a time does not solve the problem. (gjw 20250316)
  //   //
  //   // A work around is to generate an evaluation for one model at a time, then
  //   // have a break! But did not work.

  //   // for (String script in scripts) {
  //   //   _rSource(context, ref, [script]);
  //   // }

  //   // In this case simply pass through. This is the original implementation.

  //   _rSource(context, ref, scripts);

  //   // Could try a delay after ever script.

  // //      await Future.delayed(Duration(milliseconds: 500));
  // }

  // Future<void> _rSource(
  //   BuildContext context,
  //   WidgetRef ref,
  //   List<String> scripts,
) async {
  // We first check that the R CONSOLE is ready to accept commands. This is done
  // by checking for the `> ` prompt as the final two characters in stdout. If
  // we don't find it then we loop here for 5 seconds waiting for the '> '
  // string in stdout. If not there after 5s then add a popup here to note that
  // the R CONSOLE is not yet ready to accept this action and so it will not be
  // run at this time. The message should instruct the user to view the CONSOLE
  // to understand why R is not ready. There is then an OKAY button in the popup
  // and we immediately return from this function without submitting the
  // script. Add an optional parameter to this function to do this test. If
  // true, the default, then we do the test. If false then skip this test. Thus
  // all current calls to rScript() will work but have this added test
  // automatically while we can override it if it is problematic in specific
  // cases. (gjw 20250511)

  // 20260819 gjw The traffic light goes yellow here, at the start, rather than
  // further down where the code is handed to R. Getting from here to there
  // means reading the shared preferences, loading each script from the assets
  // and substituting through it, all of which is awaited, so the light was
  // still showing green from the last script for as long as that took. A user
  // pressing a button had no sign that anything was happening yet, and a test
  // that asks whether R is busy was told it was not and went on to read a page
  // R had not filled in yet. On a quick machine that gap is nothing; on a
  // slower one it is not, which is where it showed up.
  //
  // There is no early return between here and the write below, so the light
  // cannot be left yellow by this.

  ref.read(rStatusProvider.notifier).state = RStatus.running;

  String stdout = ref.read(stdoutProvider);
  if (stdout.isNotEmpty && stdout.substring(stdout.length - 2) != '> ') {
    debugText('  TRACE **', 'CONSOLE **IS NOT** READY ***************');
    // LOOP HERE FOR 5 SECONDS  WAITING FOR THE '> ' THEN FAIL WITH POPUP
  } else {
    debugText('  TRACE **', 'CONSOLE is ready');
  }

  // 20250213 gjw Be sure to load the partition information from shared
  // preferences and so update the provider appropraitely so that the user's
  // selected preferred partitioning is immediately available on startup.

  final prefs = await SharedPreferences.getInstance();

  final trainValue =
      prefs.getInt('train') ?? ref.read(partitionTrainProvider.notifier).state;
  ref.read(partitionTrainProvider.notifier).state = trainValue;

  final tuneValue =
      prefs.getInt('tune') ?? ref.read(partitionTuneProvider.notifier).state;
  ref.read(partitionTuneProvider.notifier).state = tuneValue;

  final testValue =
      prefs.getInt('test') ?? ref.read(partitionTestProvider.notifier).state;
  ref.read(partitionTestProvider.notifier).state = testValue;

  // Update the partition setting provider with the loaded values
  ref.read(partitionSettingProvider.notifier).state = [
    trainValue / 100,
    tuneValue / 100,
    testValue / 100,
  ];

  // Initialise the state variables obtained from the different providers.

  // TODO 20250131 gjw MIGRATE TO NOT CACHE THE VALUES HERE
  //
  // Instead directly use ref.read() later as with neuralMaxWeightsProvider.

  int randomSeedSetting = ref.read(randomSeedSettingProvider);
  bool randomPartitionSetting = ref.read(randomPartitionSettingProvider);

  bool cleanse = ref.read(cleanseProvider);
  bool normalise = ref.read(normaliseProvider);
  bool partition = ref.read(partitionProvider);
  String corpusSaveName = ref.read(corpusSaveNameProvider);

  String groupBy = ref.read(groupByProvider);
  String imputed = ref.read(imputedProvider);
  String selected = ref.read(selectedProvider);
  String selected2 = ref.read(selected2Provider);

  int maxFactor = ref.read(maxFactorProvider);

  bool nnetTrace = ref.read(traceNeuralProvider);
  bool nnetSkip = ref.read(neuralSkipProvider);
  List<double> partitionRatios = ref.read(partitionSettingProvider);
  String partitionString =
      '${partitionRatios.first}, ${partitionRatios[1]}, ${partitionRatios.last}';

  // ASSOCIATION

  bool associationBaskets = ref.read(basketsAssociationProvider);
  double associationSupport = ref.read(supportAssociationProvider);
  double associationConfidence = ref.read(confidenceAssociationProvider);
  int associationMinLength = ref.read(minLengthAssociationProvider);
  int associationInterestMeasureLimit = ref.read(
    interestMeasuresAssociationProvider,
  );
  String associationRulesSortBy =
      ref.read(sortByAssociationProvider).toLowerCase();

  // CLUSTER

  int clusterNum = ref.read(numberClusterProvider);
  int clusterRun = ref.read(runClusterProvider);
  int clusterProcessor = ref.read(processorClusterProvider);
  int clusterPairSize = ref.read(pairSizeClusterProvider);
  bool clusterReScale = ref.read(reScaleClusterProvider);
  String clusterDistance = ref.read(distanceClusterProvider);
  String clusterLink = ref.read(linkClusterProvider);
  String clusterType = ref.read(typeClusterProvider);

  // EVALUATE

  String datasetType = ref.read(datasetTypeProvider);

  // FOREST

  int forestTrees = ref.read(treeNumForestProvider);
  String? forestSampleSize = ref.read(forestSampleSizeProvider);
  int forestPredictorNum = ref.read(predictorNumForestProvider);
  int forestNo = ref.read(treeNoForestProvider);
  int forestMaxRules = ref.read(maxRulesForestProvider);
  bool forestImpute = ref.read(imputeForestProvider);

  // LINEAR

  String linearFamily = ref.read(familyLinearProvider).toLowerCase();

  // SETTINGS

  bool useValidation = ref.read(useValidationSettingProvider);

  String theme = ref.read(settingsGraphicThemeProvider);

  // SVM

  RegExp regex = RegExp(r'\(([^)]+)\)');
  String svmKernelItem = ref.read(kernelSVMProvider);
  final match = regex.firstMatch(svmKernelItem);
  String svmKernel = match != null ? match.group(1)! : '';

  int svmDegree = ref.read(degreeSVMProvider);

  // VISUAL

  bool ignoreMissingGroupBy = ref.read(ignoreMissingGroupByProvider);
  bool exploreVisualBoxplotNotch = ref.read(exploreVisualBoxplotNotchProvider);

  int interval = ref.read(intervalProvider);

  // First obtain the text from each script and combine.

  String code = '';
  String newCode = '';

  for (String script in scripts) {
    debugText('R SOURCE', '$script.R');

    String asset = 'assets/r/$script.R';

    if (!context.mounted) return;

    newCode = await DefaultAssetBundle.of(context).loadString(asset);
    newCode = rStripHeader(newCode);
    newCode = rStripTodo(newCode);
    newCode = "\n${'#' * 72}\n## -- $script.R --\n${'#' * 72}\n$newCode";

    code += newCode;
  }

  code = await mapGlobal(ref, code);

  ////////////////////////////////////////////////////////////////////////
  // SETTINGS

  code = code.replaceAll('<MAXFACTOR>', maxFactor.toString());

  code = code.replaceAll(
    '<RANDOM_PARTITION>',
    randomPartitionSetting.toString().toUpperCase(),
  );
  code = code.replaceAll('<RANDOM_SEED>', randomSeedSetting.toString());

  code = code.replaceAll('<SETTINGS_GRAPHIC_THEME>', theme);

  code = code.replaceAll(
    '<TUNING_TYPE>',
    useValidation ? 'validation' : 'tuning',
  );

  ////////////////////////////////////////////////////////////////////////
  // DATASET ROLES
  //
  // The `roles` Provider lists the roles for the different variables which we
  // need to know for parsing the R scripts.

  Map<String, Role> roles = ref.read(rolesProvider);

  // Initialise the different roles for the global dataset variables.

  String target = 'NULL'; // 20250202 gjw Required for predictive models.
  String risk = 'NULL'; // 20250202 gjw Optional for predictive models.

  // TARGET

  // Extract the target variable from the rolesProvider.

  roles.forEach((key, value) {
    if (value == Role.target) {
      target = key;
    }
  });

  // 20250202 gjw If the target is NULL (no target has been identified) then we
  // need to ensure expressions in the R code like
  //
  // target <- <TARGET_VAR>
  //
  // becomes
  //
  // target <- NULL
  //
  // otherwise
  //
  // target <- "rain_tomorrow"
  //
  // A naive approach ends up with "NULL" as the variable called NULL rather
  // than being NULL. We handle this special case and then replace any other
  // TARGET_VAR replacement as usual.

  code = code.replaceAll(
    '<TARGET_VAR>',
    target == 'NULL' ? 'NULL' : '"$target"',
  );

  //code = code.replaceAll('<TARGET_VAR>', ref.read(rolesProvider));

  // RISK

  // Extract the risk variable from the rolesProvider and use that for now as
  // the variable to visualise.

  roles.forEach((key, value) {
    if (value == Role.risk) {
      risk = key;
    }
  });

  code = code.replaceAll('<RISK_VAR>', risk == 'NULL' ? 'NULL' : '"$risk"');

  // IDENTIFIERS

  // 20250202 gjw If we need a single identifier then take the first one
  // available.

  String ident = 'NULL'; // 20250202 gjw Used in associations.

  roles.forEach((key, value) {
    if (ident == 'NULL' && value == Role.ident) {
      ident = key;
    }
  });

  code = code.replaceAll('<IDENT_VAR>', ident == 'NULL' ? 'NULL' : '"$ident"');

  // 20250206 gjw If we need to identify all identifiers then build the list.

  String idents = '';

  roles.forEach((key, value) {
    if (value == Role.ident) {
      idents = '$idents${idents.isNotEmpty ? ", " : ""}"$key"';
    }
  });

  code = code.replaceAll('<IDENT_VARS>', idents == '' ? 'NULL' : 'c($idents)');

  // IGNORED

  List<String> ignoredVars = getIgnored(ref);
  String ignoredVarsString = toRVector(ignoredVars);
  code = code.replaceAll('<IGNORE_VARS>', ignoredVarsString);

  List<String> result = getMissing(ref);
  code = code.replaceAll('<MISSING_VARS>', toRVector(result));

  code = mapBoost(ref, code);

  ////////////////////////////////////////////////////////////////////////

  // LINEAR

  code = code.replaceAll('<LINEAR_FAMILY>', '"$linearFamily"');

  // NEEDS_INIT is true for Windows as main.R does not get run on startup on
  // Windows.

  // String needsInit = 'FALSE';
  // if (Platform.isWindows) needsInit = 'TRUE';

  // code = code.replaceAll('<NEEDS_INIT>', needsInit);

  // Do we split the dataset? The option is presented on the DATASET GUI, and if
  // set we split the dataset.

  // TODO if (script.contains('^dataset_')) {

  // Do we split the dataset? The option is presented on the DATASET GUI, and if
  // set we split the dataset.

  code = code.replaceAll('<SPLIT_DATASET>', partition ? 'TRUE' : 'FALSE');

  // Do we want to normalise the dataset? The option is presented on the DATASET
  // GUI, and if set we normalise the dataset's variable names.

  code = code.replaceAll('<NORMALISE_NAMES>', normalise ? 'TRUE' : 'FALSE');

  // Do we want to cleanse the dataset? The option is presented on the DATASET
  // GUI, and if it is set we will cleanse the dataset columns.

  code = code.replaceAll('<CLEANSE_DATASET>', cleanse ? 'TRUE' : 'FALSE');

  code = code.replaceAll('<INTERVAL>', interval.toString());
  code = code.replaceAll('<NUMBER>', ref.read(numberProvider).toString());
  code = code.replaceAll('<SELECTED_VAR>', selected);

  code = code.replaceAll('<SELECTED_2_VAR>', selected2);

  code = code.replaceAll(
    '<GROUP_BY_VAR>',
    groupBy == 'None' ? 'NULL' : groupBy,
  );

  code = code.replaceAll('<IMPUTED_VALUE>', imputed);

  // Replace DATA_SPLIT_TR_TU_TE with the current values from
  // partitionSettingProvider.

  code = code.replaceAll('<DATA_SPLIT_TR_TU_TE>', partitionString);

  code = mapRpart(ref, code);

  ////////////////////////////////////////////////////////////////////////
  // ASSOCIATE

  code = code.replaceAll(
    '<ASSOCIATION_BASKETS>',
    associationBaskets ? 'TRUE' : 'FALSE',
  );
  code = code.replaceAll(
    '<ASSOCIATION_SUPPORT>',
    associationSupport.toString(),
  );
  code = code.replaceAll(
    '<ASSOCIATION_CONFIDENCE>',
    associationConfidence.toString(),
  );
  code = code.replaceAll(
    '<ASSOCIATION_MIN_LENGTH>',
    associationMinLength.toString(),
  );

  code = code.replaceAll(
    '<ASSOCIATION_INTEREST_MEASURE>',
    associationInterestMeasureLimit.toString(),
  );

  code = code.replaceAll(
    '<ASSOCIATION_RULES_SORT_BY>',
    '"$associationRulesSortBy"',
  );

  ////////////////////////////////////////////////////////////////////////
  // CLUSTER

  code = code.replaceAll('<CLUSTER_NUM>', clusterNum.toString());
  code = code.replaceAll('<CLUSTER_RUN>', clusterRun.toString());
  code = code.replaceAll(
    '<CLUSTER_RESCALE>',
    clusterReScale ? 'TRUE' : 'FALSE',
  );
  code = code.replaceAll('<CLUSTER_TYPE>', '"${clusterType.toString()}"');
  code = code.replaceAll('<CLUSTER_TYPE_STR>', clusterType.toString());

  code = code.replaceAll(
    '<CLUSTER_DISTANCE>',
    '"${clusterDistance.toString()}"',
  );
  code = code.replaceAll('<CLUSTER_LINK>', '"${clusterLink.toString()}"');
  code = code.replaceAll('<CLUSTER_PROCESSOR>', clusterProcessor.toString());
  code = code.replaceAll('<CLUSTER_PAIR_SIZE>', clusterPairSize.toString());
  ////////////////////////////////////////////////////////////////////////
  // EXPLORE - VISUAL - BOXPLOT

  code = code.replaceAll(
    '<BOXPLOT_NOTCH>',
    exploreVisualBoxplotNotch.toString().toUpperCase(),
  );

  code = code.replaceAll(
    '<IGNORE_MISSING_GROUP_BY>',
    ignoreMissingGroupBy.toString().toUpperCase(),
  );

  // EVALUATE

  code = code.replaceAll('<DATASET_TYPE>', datasetType.toUpperCase());

  // The dataset loaded to evaluate the model against, if any.

  code = code.replaceAll(
    '<EVAL_FILENAME>',
    ref.read(evaluateDatasetPathProvider),
  );

  // The CSV file that the evaluation results are exported to.

  code = code.replaceAll(
    '<EXPORT_FILENAME>',
    ref.read(evaluateExportPathProvider),
  );

  // The INTERACTIVE prediction popup builds both of these as R code, the
  // variables to describe and the single row observation to predict.

  code = code.replaceAll(
    '<INTERACTIVE_INPUTS>',
    ref.read(interactiveInputsProvider),
  );

  code = code.replaceAll(
    '<INTERACTIVE_NEWDATA>',
    ref.read(interactiveNewdataProvider),
  );

  ////////////////////////////////////////////////////////////////////////
  // FOREST

  code = code.replaceAll('<RF_NUM_TREES>', forestTrees.toString());
  code = code.replaceAll('<RF_MTRY>', forestPredictorNum.toString());
  code = code.replaceAll('<RF_NO_TREE>', forestNo.toString());
  code = code.replaceAll('<RF_MAX_SHOW_RULES>', forestMaxRules.toString());
  code = code.replaceAll(
    '<RF_NA_ACTION>',
    forestImpute ? 'randomForest::na.roughfix' : 'na.omit',
  );

  code = code.replaceAll(
    '<RF_INPUT_SAMPSIZE>',
    forestSampleSize == null
        ? ''
        : forestSampleSize.isEmpty
            ? ''
            : ', sampsize = c($forestSampleSize)',
  );

  code = mapNeural(ref, code);

  ////////////////////////////////////////////////////////////////////////
  // SVM

  code = code.replaceAll('<SVM_KERNEL>', '"${svmKernel.toString()}"');
  code = code.replaceAll('<SVM_DEGREE>', svmDegree.toString());

  code = mapWordCloud(ref, code);

  // Handle DTM CSV save path.

  code = code.replaceAll('<CORPUS_SAVE_NAME>', corpusSaveName);

  ////////////////////////////////////////////////////////////////////////

  code = code.replaceAll('<NNET_TRACE>', nnetTrace ? 'TRUE' : 'FALSE');
  code = code.replaceAll('<NNET_SKIP>', nnetSkip ? 'TRUE' : 'FALSE');

  ////////////////////////////////////////////////////////////////////////

  // read the boolean value from the provider.

  bool includeCrossTab = ref.watch(crossTabSummaryProvider);

  // Cross tabulation summary.

  code = code.replaceAll(
    '<SUMMARY_CROSS_TAB>',
    includeCrossTab ? 'TRUE' : 'FALSE',
  );

  ////////////////////////////////////////////////////////////////////////

  // Add the code to the script provider so it will be displayed in the script
  // tab and available to be exported there.

  updateScript(ref, code);

  // Run the code without comments.

  code = rStripComments(code);

  // Add a completion marker.

  // code = '$code\nprint("Processing $script Completed")\n';

  List<String> lines = code.split('\n');
  debugText('R CODE LENGTH', '${lines.length} lines');

  // EXPERIMENTAL Set to 2000 to skip this splitting.
  //
  // Had a problem with model_build_rforest.R and it seemed that the code was
  // getting truncated going to the R console. Trying sending it in two
  // segments. The segmenting seemed to work but need to keep an eye on it! The
  // 200 lines was chonsen because the model_template then model_build_rforest
  // was 286 lines of code. It may be char length rather than line count that is
  // important though. (gjw 20250513)

  // 20260816 gjw The traffic light of the app bar went yellow at the top of this
  // function, when the work was asked for. `providers/pty.dart` turns it green
  // again when R settles back at its prompt, or red if R reports an error.

  if (lines.length > 200) {
    String code1 = '${lines.take(200).join('\n')}\n';
    String code2 = lines.skip(200).join('\n');

    ref.read(ptyProvider).write(const Utf8Encoder().convert(code1));
    ref.read(ptyProvider).write(const Utf8Encoder().convert(code2));
  } else {
    ref.read(ptyProvider).write(const Utf8Encoder().convert(code));
  }
  // Optionally, show a SnackBar when the script finishes executing.

  //  if (code.contains('Processing $script Completed')) {
  setStatus(
    ref,
    'R scripts completed. See **Console** for details, **Script** for R code.\n'
    '**$scripts**',
  );
  // if (context.mounted) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Row(
  //         children: [
  //           const Icon(Icons.thumb_up, color: Colors.blue),
  //           const SizedBox(width: 40),
  //           Expanded(
  //             child: Text(
  //               'Execution of $script.R is completed.',
  //               style: const TextStyle(color: Colors.blue),
  //             ),
  //           ),
  //         ],
  //       ),
  //       backgroundColor: const Color(0xFFBBDEFB),
  //       elevation: 5,
  //       behavior: SnackBarBehavior.floating,
  //       shape: const StadiumBorder(),
  //       width: 600,
  //       // margin: const EdgeInsets.fromLTRB(10, 0, 300, 0),
  //       // Set a short duration
  //       duration: const Duration(seconds: 1),
  //       action: SnackBarAction(
  //         label: 'Okay',
  //         disabledTextColor: Colors.white,
  //         textColor: Colors.blue,
  //         onPressed: () {},
  //       ),
  //     ),
  //   );
  // }
  //  }
}
