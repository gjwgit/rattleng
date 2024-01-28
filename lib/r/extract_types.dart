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
Future<List<String>> rExtractTypes(String text) async {
  String startingCommand = '> classes';
  //The extracted string is
  String rExtractedString = rExtract(text, startingCommand);
  rExtractedString = rExtractedString.replaceAll(RegExp(r'"'), '\n');

  //Group Strings that start with [[digit]] and end with an array of characters as one element
  //in the list of Strings
  RegExp pattern = RegExp(r'\[\[\d+\]\]');
  rExtractedString = rExtractedString.replaceAll(pattern, '_');
  pattern = RegExp(r'\[1\]');
  rExtractedString = rExtractedString.replaceAll(pattern, '');
  rExtractedString.trim();
  List<String> types = rExtractedString.split('_');
  List<String> typesTemp = List.empty(growable: true);
  List<String> retVal = List.empty(growable: true);
  //Adding the trimmed elements of the array into a new array .
  //How to modify the old array
  for (String element in types) {
    if (element.isNotEmpty) {
      typesTemp.add(element.trim());
    }
  }

  //The created array has artefacts
  //The artefacts will be removed
  RegExp artifact = RegExp(r'\n');
  for (String element in typesTemp) {
    retVal.add(element.replaceAll(artifact, ''));
  }

  artifact = RegExp(r' ');
  List<String> nRetVal = List.empty(growable: true);
  for (String element in retVal) {
    nRetVal.add(element.replaceAll(artifact, ','));
  }

  artifact = RegExp(r'\[1C');
  List<String> ret = List.empty(growable: true);
  for (String element in nRetVal) {
    ret.add(element.replaceAll(artifact, ''));
  }
  for (String element in ret) {
    debugPrint(element);
  }

  debugPrint("The number of columns in the dataset is  ${ret.length}");
  return ret;
}
