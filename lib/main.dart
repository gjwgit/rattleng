import 'dart:io';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:window_size/window_size.dart';

import 'package:rattle/helpers/constants.dart';
import 'package:rattle/screens/main/main_screen.dart';


void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      setWindowTitle("Rattle for Data Science");
    }
  
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rattling Data for Scientist',
      theme: ThemeData(
        primarySwatch: createMaterialColor(const Color(0xff45035e)),
        fontFamily: GoogleFonts.openSans().fontFamily,
      ),
      home: const MainScreen(title: 'Rattle New Generation')
    );
  }
}
