import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'form_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grua Help App',
      theme: ThemeData(
          scaffoldBackgroundColor: Color.fromARGB(255, 190, 202, 207),
          appBarTheme: AppBarTheme(
              backgroundColor: Color.fromARGB(255, 9, 84, 86),
              elevation: 0,
              centerTitle: true,
              titleTextStyle: GoogleFonts.nunito(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  fontSize: 20))),
      home: const FormPage(),
    );
  }
}
