import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:rattle/helpers/constants.dart';
import 'package:rattle/screens/main/MainScreen.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of the application.
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rattle: R Data Science',
      theme: ThemeData(
        primarySwatch: createMaterialColor(Color(0xffBE830E)),
        fontFamily: GoogleFonts.openSans().fontFamily,
      ),
      home: MainScreen(title: 'Rattle New Generation')
    );
  }
}
