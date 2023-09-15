/// Load the specified dataset using the appropriate R script.
///
/// The R script is expected to load the data into the template variable `ds`,
/// and define `dsname` as the dataset name and `vnames` as a named list of the
/// original variable names with values the current variable names, being
/// different in the case where the dataset variables have been normalised,
/// which is the default.

import 'package:rattle/helpers/r_source.dart';

void buildModel() {
  null;
  // THESE NEED TO PASS RATTLE TO IT
  //rSource("model_template");
  //rSource("rpart_build");
}
