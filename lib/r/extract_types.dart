import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/provider/path.dart';
import 'package:rattle/provider/stdout.dart';
import 'package:rattle/provider/target.dart';
import 'package:rattle/provider/vars.dart';
import 'package:rattle/r/execute.dart';
import 'package:rattle/r/extract_vars.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/r/extract.dart';

//Get the types of variables from the text  provided
//The [text] is the output from the console
//Assuming that classes<-unname(sapply(ds,class)) and print(classes)
//has been executed
void rExtractTypes(String text) {
  //The first command that should be executed
  //It is unclear as to how the first command would be executed?
k
  //The starting command meant to identify the types
  String startingCommand = '> classes';
  //The extracted string is
  String rExtractedString = rExtract(text, startingCommand);
  debugPrint("The command that was output was : $rExtractedString");
}

void loadTypes(WidgetRef ref) {
  rExecute(ref, "classes");
}
