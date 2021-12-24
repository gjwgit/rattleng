import 'dart:io';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:window_size/window_size.dart';

import 'package:rattle/helpers/constants.dart';
import 'package:rattle/screens/main/MainScreen.dart';


void main() {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle("Rattle for Data Science");
  }
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rattling Data for Scientist',
      theme: ThemeData(
        primarySwatch: createMaterialColor(Color(0xff45035e)),
        fontFamily: GoogleFonts.openSans().fontFamily,
      ),
      home: MainScreen(title: 'Rattle New Generation')
    );
  }
}
