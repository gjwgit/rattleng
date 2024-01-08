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
  String startingCommand = '> classes';
  //The extracted string is
  String rExtractedString = rExtract(text, startingCommand);

  //from the extracted string , remove all the numbers
  // Remove all numbers from the extracted string
  rExtractedString = rExtractedString.replaceAll(RegExp(r'\d+'), '');
  //Process the varnames using regexp to remove "[]" aretefacts
  RegExp pattern = RegExp(r'[^a-zA-Z]');
  rExtractedString = rExtractedString.replaceFirstMapped(pattern, (m) => '\n');

  List<String> tempList = rExtractedString.split('\n');
  List<String> nTempList = List.empty(growable: true);
  //Add the modified string to a new list
  for (String element in tempList) {
    nTempList.add(element.replaceAllMapped(pattern, (match) => ''));
  }

  debugPrint("The command that was output was : $rExtractedString");
  debugPrint("parsed : $nTempList");
}
